require 'rails_helper'
require 'models/shared/trackable'
include Stubs::AddressApi

RSpec.describe Location, type: :model do
  before { stub_address_api! }

  it_behaves_like :a_trackable

  it 'has a valid factory' do
    # A factory_girl issue causes problems here, will be (hopefully soon) fixed by
    # https://github.com/thoughtbot/factory_girl/issues/981
    # expect(build_stubbed(:location)).to be_valid
    # expect(build_stubbed(:location, :approved)).to be_valid
  end

  describe 'validations' do
    it 'is invalid without name' do
      expect(build(:location, name: '')).not_to be_valid
    end

    it 'is invalid without graetzl' do
      expect(build(:location, graetzl: nil)).not_to be_valid
    end

    it 'is invalid without location_category' do
      expect(build(:location, location_category: nil)).not_to be_valid
    end
  end

  describe 'attr macros' do
    let(:location) { create(:location) }

    it 'has friendly_id' do
      expect(location).to respond_to(:slug)
    end

    it 'has state default :pending' do
      expect(location).to respond_to(:state)
      expect(location.pending?).to be true
    end

    it 'has meeting_permission, default :meetable' do
      expect(location).to respond_to(:meeting_permission)
      expect(location.meetable?).to be true
    end

    it 'has avatar with content_type' do
      expect(location).to respond_to(:avatar)
      expect(location).to respond_to(:avatar_content_type)
    end

    it 'has cover_photo with content_type' do
      expect(location).to respond_to(:cover_photo)
      expect(location).to respond_to(:cover_photo_content_type)
    end

    it 'has product_list (tags)' do
      expect(location).to respond_to :product_list
    end
  end

  describe 'associations' do
    let(:location) { create(:location) }

    it 'has graetzl' do
      expect(location).to respond_to(:graetzl)
    end

    it 'has location_category' do
      expect(location).to respond_to(:location_category)
    end

    it 'has meetings' do
      expect(location).to respond_to(:meetings)
    end

    it 'has billing_address' do
      expect(location).to respond_to :billing_address
    end

    describe 'address' do
      it 'has address' do
        expect(location).to respond_to(:address)
      end

      it 'destroys address with location' do
        create :address, addressable: location
        expect{
          location.destroy
        }.to change{Address.count}.by -1
      end
    end

    describe 'users' do
      it 'has users' do
        expect(location).to respond_to(:users)
      end

      it 'destroys ownerships with location' do
        create_list :location_ownership, 3, location: location
        expect{
          location.destroy
        }.to change{LocationOwnership.count}.by -3
      end
    end

    describe 'contact' do
      it 'has contact' do
        expect(location).to respond_to(:contact)
      end

      it 'destroys contact with location' do
        create :contact, location: location
        expect{
          location.destroy
        }.to change(Contact, :count).by -1
      end
    end

    describe 'posts' do
      it 'has posts' do
        expect(location).to respond_to(:posts)
      end

      it 'destroys posts with location' do
        create_list(:location_post, 3, author: location)
        expect{
          location.destroy
        }.to change{Post.count}.by -3
      end
    end

    describe 'zuckerl' do
      before { allow_any_instance_of(Zuckerl).to receive(:send_booking_confirmation) }
      it 'has zuckerls' do
        expect(location).to respond_to :zuckerls
      end

      it 'destroys zuckerls with location' do
        create_list :zuckerl, 3, location: location
        expect{
          location.destroy
        }.to change(Zuckerl, :count).by -3
      end
    end
  end

  describe '#can_create_meeting?' do
    let!(:location) { create(:location) }

    context 'when meeting_permission meetable' do
      before { location.meetable! }

      it 'returns true for any user' do
        expect(location.can_create_meeting?(build(:user))).to eq true
      end
    end

    context 'when meeting_permission owner_meetable' do
      let(:owner) { create(:user) }
      before do
        location.owner_meetable!
        create(:location_ownership, location: location, user: owner)
      end

      it 'returns false for random user' do
        expect(location.can_create_meeting?(build(:user))).to eq false
      end

      it 'returns true for owner' do
        expect(location.can_create_meeting?(owner)).to eq true
      end
    end

    context 'when meeting_permission non_meetable' do
      before { location.non_meetable! }

      it 'returns false for any user' do
        expect(location.can_create_meeting?(build(:user))).to eq false
      end
    end
  end

  describe '#approve' do
    context 'when location pending' do
      let(:location) { create(:location, state: Location.states[:pending]) }

      it 'changes state to approved' do
        expect{
          location.approve
        }.to change{location.state}.to 'approved'
      end

      it 'returns activity' do
        expect(location.approve).to be_truthy
      end

      it 'logs :approve activity' do
        expect(location.activities).to be_empty
        location.approve
        location.reload
        expect(location.activities).not_to be_empty
        expect(location.activities.last.key).to eq 'location.approve'
      end
    end

    context 'when location not pending' do
      let(:location) { create(:location, state: Location.states[:approved]) }

      it 'keeps state' do
        expect{
          location.approve
        }.not_to change(location, :state)
      end

      it 'returns false' do
        expect(location.approve).to eq nil
      end
    end
  end

  describe '#reject' do
    context 'when location pending' do
      let!(:location) { create(:location, state: Location.states[:pending]) }

      it 'returns location' do
        expect(location.reject).to eq location
      end

      it 'destroys record' do
        expect{
          location.reject
        }.to change(Location, :count).by(-1)
      end
    end

    context 'when location approved' do
      let(:location) { create(:location, state: Location.states[:approved]) }

      it 'keeps state' do
        expect{
          location.reject
        }.not_to change(location.reload, :state)
      end

      it 'returns false' do
        expect(location.reject).to eq nil
      end
    end
  end

  describe '#boss' do
    let(:location) { create :location }
    let(:owner) { create :user }
    before do
      create(:location_ownership, user: owner, location: location)
      create_list(:location_ownership, 3, location: location)
    end

    it 'returs first user' do
      expect(location.users.count).to eq 4
      expect(location.boss).to eq owner
    end
  end

  describe '#editable_by' do
    let(:location) { create :location }
    let(:user) { create :user }

    subject(:edit_state) { location.editable_by?(user) }

    it 'returns true for owners' do
      create :location_ownership, user: user, location: location
      expect(edit_state).to eq true
    end

    it 'returns false for other users' do
      expect(edit_state).to eq false
    end
  end

  describe '#build_meeting' do
    let(:graetzl) { create :graetzl }
    let(:location) { create :location, :approved, graetzl: graetzl }

    subject(:meeting) { location.build_meeting }

    it 'builds meeting in location graetzl' do
      expect(meeting).to have_attributes(location: location, graetzl: graetzl)
    end

    it 'builds meeting without address' do
      expect(meeting.address).to be_nil
    end
  end
end
