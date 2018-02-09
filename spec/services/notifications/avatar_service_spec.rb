require 'rails_helper'

RSpec.describe Notifications::AvatarService do
  before do
    allow(Refile).to receive(:token).and_return('token')
  end

  describe 'call' do
    context 'behind cdn' do
      before do
        allow(Refile).to receive(:cdn_host).and_return('123.cloudfront.com')
      end

      context 'when object with avatar' do
        let(:user) { build(:user, avatar_id: 'abcdefg2000', avatar_content_type: 'image/jpeg') }
        let(:service) { Notifications::AvatarService.new user }

        subject(:url) { service.call }

        it 'returns cdn url for avatar' do
          expect(url).to eq "http://123.cloudfront.com/attachments/token/store/fill/200/200/abcdefg2000/avatar.jpeg"
        end
      end
      context 'when user withou avatar' do
        let(:user) { build :user }
        let(:service) { Notifications::AvatarService.new user }

        subject(:url) { service.call }

        it 'returns cdn url for fallback user avatar' do
          expect(url).to match /^http:\/\/123.cloudfront.com\/assets\/avatar\/user\/200x200-\w*.png/
        end
      end
      context 'when location withou avatar' do
        let(:location) { build :location }
        let(:service) { Notifications::AvatarService.new location }

        subject(:url) { service.call }

        it 'returns cdn url for fallback location avatar' do
          expect(url).to match /^http:\/\/123.cloudfront.com\/assets\/avatar\/location\/200x200-\w*.png/
        end
      end
    end

    context 'without cdn' do
      context 'when object with avatar' do
        let(:user) { build(:user, avatar_id: 'abcdefg2000', avatar_content_type: 'image/jpeg') }
        let(:service) { Notifications::AvatarService.new user }

        subject(:url) { service.call }

        it 'returns app url for avatar' do
          expect(url).to eq "http://test.yourhost.com/attachments/token/store/fill/200/200/abcdefg2000/avatar.jpeg"
        end
      end
      context 'when user withou avatar' do
        let(:user) { build :user }
        let(:service) { Notifications::AvatarService.new user }

        subject(:url) { service.call }

        it 'returns app url for fallback user avatar' do
          expect(url).to match /^http:\/\/test.yourhost.com\/assets\/avatar\/user\/200x200-\w*.png/
        end
      end
      context 'when location withou avatar' do
        let(:location) { build :location }
        let(:service) { Notifications::AvatarService.new location }

        subject(:url) { service.call }

        it 'returns app url for fallback location avatar' do
          expect(url).to match /^http:\/\/test.yourhost.com\/assets\/avatar\/location\/200x200-\w*.png/
        end
      end
    end
  end
end
