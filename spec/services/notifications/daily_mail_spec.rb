require 'rails_helper'

RSpec.describe Notifications::DailyMail do
  let!(:user) { create :user }
  before do
    allow_any_instance_of(Notifications::NewMeeting).to receive(:mail_vars).and_return({})
    stub_const('MANDRILL_API_KEY', 'somestring')
    stub_request(:post, "https://mandrillapp.com/api/1.0/messages/send-template.json").
         to_return(:status => 200,:body => '{"some":"thing"}', :headers => {"Content-Type"=> "application/json"})
  end

  describe '_#notification_block' do
    let(:service) { Notifications::DailyMail.new(user) }
    let(:type) { Notifications::NewMeeting }

    before { user.enable_mail_notification(type, :daily) }

    subject(:block) { service.send(:notification_block, 'name', [type]) }

    context 'when notifications available' do
      before do
        create_list(:notification, 3, user: user, type: type, bitmask: type::BITMASK)
        Notification.update_all(created_at: Date.yesterday)
      end

      it 'is not empty' do
        expect(block).not_to be_empty
      end

      it 'contains name and array of notification vars' do
        expect(block[:name]).to eq 'name'
        expect(block[:notifications]).to be_a(Array)
      end
    end

    context 'when no notifications' do
      it 'returns nil' do
        expect(block).to eq nil
      end
    end
  end

  describe '_#notification_blocks' do
    let(:service) { Notifications::DailyMail.new(user) }
    subject(:blocks) { service.send(:notification_blocks) }

    context 'when no notifications' do
      it 'returns empty array' do
        expect(blocks).to eq []
      end
    end

    context 'when notifications for one block' do
      let(:type) { Notifications::NewMeeting }
      before do
        user.enable_mail_notification(type, :daily)
        create_list(:notification, 3, user: user, type: type, bitmask: type::BITMASK)
        Notification.update_all(created_at: Date.yesterday)
      end

      it 'returns array with one hash' do
        expect(blocks.size).to eq 1
        expect(blocks.first).to be_a(Hash)
      end
    end
  end

  describe '#_build_message' do
    let(:service) { Notifications::DailyMail.new(user) }
    subject(:message_hash) { service.send(:build_message) }

    context 'when notification_blocks available' do
      before { allow(service).to receive(:notification_blocks){['content']} }

      it 'has keys for mandrill' do
        expect(message_hash.keys).to contain_exactly(:to,
                                              :from_email,
                                              :from_name,
                                              :subject,
                                              :global_merge_vars,
                                              :merge_vars)
      end

      it 'has keys for daily mail' do
        expect(message_hash[:merge_vars]).to be_a(Array)
        expect(message_hash[:merge_vars][0]).to be_a(Hash)
        expect(message_hash[:merge_vars][0][:vars]).not_to be_empty
      end
    end

    context 'when no notification_blocks available' do
      before { allow(service).to receive(:notification_blocks){Array.new} }

      it 'returns empty hash' do
        expect(message_hash).to eq nil
      end
    end
  end

  describe '#deliver' do
    let(:service) { Notifications::DailyMail.new(user) }
    
    context 'when message available' do
      let(:type) { Notifications::NewMeeting }
      let(:notification) { create(:notification, user: user, sent: false, type: type, bitmask: type::BITMASK) }

      before do
        user.enable_mail_notification(type, :daily)
        notification.update(created_at: Date.yesterday)
        allow(service).to receive(:build_message){[{name: 'something'}]}
      end

      it 'calls mandrill api' do
        service.deliver
        expect(WebMock).to have_requested(:post, 'https://mandrillapp.com/api/1.0/messages/send-template.json')
      end

      it 'updates :sent for all sent notifications' do
        expect{
          service.deliver
          notification.reload
        }.to change{notification.sent}.from(false).to(true)
      end
    end

    context 'when no message available' do
      it 'does nothing' do
        expect(service.deliver).to eq nil
      end

      it 'does not call mandrill api' do
        service.deliver
        expect(WebMock).not_to have_requested(:post, 'https://mandrillapp.com/api/1.0/messages/send-template.json')
      end
    end
  end
end