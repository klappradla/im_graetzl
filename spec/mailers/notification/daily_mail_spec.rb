require 'rails_helper'
include Stubs::MandrillApi

RSpec.describe Notification::DailyMail do
  before { stub_mandrill_api! }

  describe 'attributes' do
    let(:user) { build_stubbed :user }
    let(:notifications) { build_stubbed_list :notification, 4, user: user }

    before { allow(user).to receive(:notifications_of_the_day){ notifications } }

    subject { described_class.new user }

    it 'has private attribute @user' do
      expect(subject.send :user).to eq user
    end
    it 'has private attribute @notifications' do
      expect(subject.send :notifications).to eq notifications
    end
  end

  describe '_#message' do
    let(:user) { create(:user) }
    let(:mailer) { described_class.new user }
    let(:type) { Notifications::NewMeeting }

    before do
      user.daily_mail_notifications = 0
      user.enable_mail_notification(type, :daily)
    end

    subject(:message) { mailer.send :generate_content }

    context 'when notifications available' do
      let!(:notifications) do
        create_list(:notification, 3,
                    :with_activity,
                    created_at: Date.yesterday,
                    user: user,
                    type: type,
                    bitmask: type::BITMASK)
      end

      it 'has basic mandrill keys' do
        expect(message.keys).to include(:to,
          :from_email,
          :from_name,
          :subject,
          :global_merge_vars,
          :merge_vars)
      end
      it 'has keys for notification mail' do
        expect(message[:merge_vars]).to be_a(Array)
        expect(message[:merge_vars][0]).to be_a(Hash)
        expect(message[:merge_vars][0][:vars]).not_to be_empty
      end
      it 'contains 3 notification items' do
        items = message[:merge_vars][0][:vars][0][:content][0][:notifications]
        expect(items.count).to eq 3
      end
    end
    context 'when no notifications available' do
      it 'returns nil' do
        expect(message).to be_nil
      end
    end
  end

  describe '#deliver' do
    let(:user) { create :user }
    let(:type) { Notifications::NewMeeting }
    let(:mailer) { described_class.new user }
    let!(:notifications) {
      create_list(:notification, 3,
        :with_activity, created_at: Date.yesterday,
        user: user, type: type, bitmask: type::BITMASK)
    }

    before do
      user.daily_mail_notifications = 0
    end

    context 'when message content' do
      before { user.enable_mail_notification(type, :daily) }

      it 'calls mandrill api' do
        mailer.deliver
        expect(WebMock).to have_requested :post, mandrill_url
      end
      it 'updates :sent for all sent notifications' do
        expect(notifications.map &:sent).to all(be false)
        mailer.deliver
        notifications.map! &:reload
        expect(notifications.map &:sent).to all(be true)
      end
    end
    context 'when not message content' do
      it 'does not call mandrill api' do
        mailer.deliver
        expect(WebMock).not_to have_requested :post, mandrill_url
      end
    end
  end
end
