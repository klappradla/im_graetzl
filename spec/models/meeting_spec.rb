require 'rails_helper'
require 'models/shared/trackable'
include Stubs::AddressApi

RSpec.describe Meeting, type: :model do
  before { stub_address_api! }

  it_behaves_like :a_trackable

  it 'has a valid factory' do
    # A factory_girl issue causes problems here, will be (hopefully soon) fixed by
    # https://github.com/thoughtbot/factory_girl/issues/981
    # expect(build_stubbed(:meeting)).to be_valid
  end

  describe 'validations' do
    it 'invalid without name' do
      expect(build(:meeting, name: nil)).not_to be_valid
    end

    it 'invalid without graetzl' do
      expect(build(:meeting, graetzl: nil)).not_to be_valid
    end

    it 'invalid when created with starts_at_date in past' do
      expect{
        create(:meeting, starts_at_date: 1.day.ago)
        }.to raise_error(ActiveRecord::RecordInvalid)
      expect(build(:meeting, starts_at_date: 1.day.ago)).not_to be_valid
    end

    it 'not invalid when updated with starts_at_date in past' do
      meeting = create(:meeting)
      expect{
        meeting.update(starts_at_date: 1.day.ago)
        }.not_to raise_error
    end
  end

  describe 'macros' do
    let(:meeting) { create(:meeting) }

    it 'has cover_photo with content_type' do
      expect(meeting).to respond_to(:cover_photo)
      expect(meeting).to respond_to(:cover_photo_content_type)
    end

    it 'has friendly_id' do
      expect(meeting).to respond_to(:friendly_id)
    end

    it 'has state (default :active)' do
      expect(meeting).to respond_to(:state)
      expect(meeting.active?).to be_truthy
    end
  end

  describe 'associations' do
    let(:meeting) { create(:meeting) }

    it 'has graetzl' do
      expect(meeting).to respond_to(:graetzl)
    end

    it 'has location' do
      expect(meeting).to respond_to(:location)
    end

    describe 'address' do
      it 'has address' do
        expect(meeting).to respond_to(:address)
      end

      it 'destroys address when destroy' do
        create(:address, addressable: meeting)
        expect{meeting.destroy}.to change{Address.count}.by -1
      end
    end

    describe 'going_tos' do
      it 'has going_tos' do
        expect(meeting).to respond_to(:going_tos)
      end

      it 'destroys going_tos when destroy' do
        create_list(:going_to, 3, meeting: meeting)
        expect{meeting.destroy}.to change{GoingTo.count}.by -3
      end
    end

    it 'has users' do
      expect(meeting).to respond_to(:users)
    end

    describe 'comments' do
      it 'has comments' do
        expect(meeting).to respond_to(:comments)
      end

      it 'destroys comments when destroy' do
        create_list(:comment, 3, commentable: meeting)
        expect{meeting.destroy}.to change{Comment.count}.by -3
      end
    end
  end

  describe 'scopes' do
    describe 'by_currentness' do
      let!(:m_yesterday) { create :meeting, :skip_validate, starts_at_date: Date.yesterday }
      let!(:m_tomorrow) { create :meeting, starts_at_date: Date.tomorrow+1.day }
      let!(:m_today) { create :meeting, starts_at_date: Date.tomorrow }

      subject(:by_currentness) { Meeting.by_currentness }

      it 'returns upcoming asc, past desc' do
        expect(by_currentness).to eq [m_today, m_tomorrow, m_yesterday]
      end
    end

    describe '.upcoming' do
      let!(:m_today) { create :meeting, starts_at_date: Date.today }
      let!(:m_tomorrow) { create :meeting, starts_at_date: Date.tomorrow }
      let!(:m_after_tomorrow) { create :meeting, starts_at_date: Date.tomorrow+1 }
      let!(:m_yesterday) { create :meeting, :skip_validate, starts_at_date: Date.yesterday }
      let!(:m_cancelled) { create :meeting, :cancelled, starts_at_date: Date.today }

      subject(:meetings) { Meeting.upcoming }

      it 'retrieves nearest first' do
        expect(meetings.to_a).to eq [m_today, m_tomorrow, m_after_tomorrow]
      end

      it 'excludes past' do
        expect(meetings).not_to include(m_yesterday)
      end

      it 'excludes cancelled' do
        expect(meetings).not_to include m_cancelled
      end
    end

    describe '.initiated' do
      let(:initiated_meetings) { create_list(:meeting, 5) }
      let(:attended_meetings) { create_list(:meeting, 5) }
      before do
        initiated_meetings.each {|m| create(:going_to, meeting: m, role: GoingTo::roles[:initiator])}
        attended_meetings.each {|m| create(:going_to, meeting: m, role: GoingTo::roles[:attendee])}
      end

      subject(:meetings) { Meeting.initiated }

      it 'returns meetings with initiator going_tos' do
        expect(meetings.to_a).to match_array(initiated_meetings)
      end
    end

    describe '.attended' do
      let(:initiated_meetings) { create_list(:meeting, 5) }
      let(:attended_meetings) { create_list(:meeting, 5) }
      before do
        initiated_meetings.each {|m| create(:going_to, meeting: m, role: GoingTo::roles[:initiator])}
        attended_meetings.each {|m| create(:going_to, meeting: m, role: GoingTo::roles[:attendee])}
      end

      subject(:meetings) { Meeting.attended }

      it 'returns meetings with attendee going_tos' do
        expect(meetings.to_a).to match_array(attended_meetings)
      end
    end
  end

  describe '#responsible_user_or_location' do
    let(:meeting) { create :meeting }
    let(:user) { create :user }

    before { create :going_to, :initiator, user: user, meeting: meeting }

    subject(:responsible) { meeting.responsible_user_or_location }

    context 'when location' do
      let(:location) { create :location }

      before { meeting.update location: location }

      it 'returns location if user owner' do
        create(:location_ownership, user: user, location: location)
        expect(responsible).to eq location
      end

      it 'returns user if not owner' do
        expect(responsible).to eq user
      end
    end
    context 'without location' do
      it 'returns initiator' do
        expect(responsible).to eq user
      end
    end
  end
  describe '#display_address' do
    let(:meeting) { create :meeting, address: nil }

    context 'when location' do
      let(:location) { create :location }

      before { meeting.update location: location }

      it 'returns address if own address' do
        address = create :address, addressable: meeting
        meeting.reload
        expect(meeting.display_address).to eq address
      end

      it 'returns location address if no own address' do
        address = create :address, addressable: location
        expect(meeting.display_address).to eq address
      end

      it 'returns nil if no address available' do
        expect(meeting.display_address).to be_nil
      end
    end
  end
end
