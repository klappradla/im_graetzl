require 'rails_helper'
include Stubs::MandrillApi

RSpec.describe Notification::ImmediateMail do
  before { stub_mandrill_api! }

  let(:mandrill_url) {
    'https://mandrillapp.com/api/1.0/messages/send-template.json' }
  let(:user) { create :user }
  let(:activity) { build_stubbed :activity,
    trackable: build_stubbed(:meeting),
    owner: build_stubbed(:user) }
  let(:notification) { build_stubbed :notification_new_meeting,
    activity: activity,
    user: user }

  describe 'attributes' do
    subject { described_class.new notification }

    it 'has private attribute @user' do
      expect(subject.send :user).to eq user
    end
    it 'has private attribute @notification' do
      expect(subject.send :notification).to eq notification
    end
  end

  describe 'immediate_mail attrs' do
    let(:mailer) { described_class.new notification }

    describe '_#template' do
      it 'returns notification template name for mandrill' do
        expect(mailer.send :template).to eq notification.mail_template
      end
    end
    describe '_#message' do
      subject(:message) { mailer.send :message }

      it 'has basic mandrill keys' do
        expect(message.keys).to include(:to,
                                        :from_email,
                                        :from_name,
                                        :subject,
                                        :global_merge_vars)
      end
      it 'has keys for immediate mail' do
        expect(message[:global_merge_vars]).to be_a(Array)
        expect(message[:global_merge_vars][0]).to be_a(Hash)
      end
    end
  end

  describe '#deliver' do
    subject { described_class.new notification }

    it 'calls mandrill api' do
      subject.deliver
      expect(WebMock).to have_requested :post, mandrill_url
    end
  end
end
