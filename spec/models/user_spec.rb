require 'rails_helper'

RSpec.describe User, type: :model do

  it 'has a valid factory' do
    expect(build_stubbed :user).to be_valid
  end

  describe 'validations' do
    it 'invalid without username' do
      expect(build :user, username: nil).not_to be_valid
    end
    it 'invalid with dublicate username' do
      first_user = create :user
      expect(build :user, username: first_user.username).not_to be_valid
    end
    it 'invalid without first_name' do
      expect(build :user, first_name: nil).not_to be_valid
    end
    it 'invalid without last_name' do
      expect(build :user, last_name: nil).not_to be_valid
    end
    it 'invalid without graetzl' do
      expect(build :user, graetzl: nil).not_to be_valid
    end
    it 'invalid with invalid website url' do
      expect(build :user, website: 'google.de').not_to be_valid
    end
  end

  describe 'callbacks' do
    let(:user) { create(:user) }

    describe 'before_validation' do
      context 'when username one word' do
        let(:user) { build(:user, username: ' name ') }

        it 'strips whitespaces on beginning and end' do
          expect{
            user.save
          }.to change{user.username.length}.from(6).to(4)
        end
      end
      context 'when username more words' do
        let(:user) { build(:user, username: ' first  second ') }

        it 'strips any double whitespaces' do
          expect{
            user.save
          }.to change{user.username}.from(' first  second ').to('first second')
        end
      end
    end
  end

  describe 'macros' do
    let(:user) { build_stubbed(:user) }

    it 'has friendly_id' do
      expect(user).to respond_to(:slug)
    end

    describe 'role' do

      it 'has one' do
        expect(user).to respond_to(:role)
      end

      context 'when admin' do
        before { user.role = :admin }

        it 'responds #admin? true' do
          expect(user.admin?).to eq(true)
        end

        it 'responds #business? false' do
          expect(user.business?).to eq(false)
        end
      end

      context 'when business' do
        before { user.business = true }

        it 'responds #business? true' do
          expect(user.business?).to eq(true)
        end

        it 'responds #admin? false' do
          expect(user.admin?).to eq(false)
        end
      end
    end

    describe 'photos' do

      it 'has avatar' do
        expect(user).to respond_to(:avatar)
      end

      it 'has avatar_content_type' do
        expect(user).to respond_to(:avatar_content_type)
      end

      it 'has cover_photo' do
        expect(user).to respond_to(:cover_photo)
      end

      it 'has cover_photo_content_type' do
        expect(user).to respond_to(:cover_photo_content_type)
      end
    end
  end

  describe 'associations' do
    let(:user) { create(:user) }

    it 'has graetzl' do
      expect(user).to respond_to(:graetzl)
    end

    it 'has meetings' do
      expect(user).to respond_to(:meetings)
    end

    it 'has locations' do
      expect(user).to respond_to(:locations)
    end

    describe 'address' do
      it 'has address' do
        expect(user).to respond_to(:address)
      end

      it 'destroys address' do
        create :address, addressable: user
        expect{
          user.destroy
        }.to change{Address.count}.by -1
      end
    end

    describe 'going_tos' do
      it 'has going_tos' do
        expect(user).to respond_to :going_tos
      end

      it 'destroys going_tos' do
        create_list :going_to, 3, user: user
        expect{
          user.destroy
        }.to change{GoingTo.count}.by -3
      end
    end

    describe 'notifications' do
      it 'has notifications' do
        expect(user).to respond_to :notifications
      end

      it 'destroys notifications' do
        create_list :notification, 3, user: user
        expect{
          user.destroy
        }.to change{Notification.count}.by -3
      end
    end

    describe 'posts' do
      it 'has posts' do
        expect(user).to respond_to :posts
      end

      it 'destroys posts' do
        create_list :user_post, 3, author: user
        expect{
          user.destroy
        }.to change{Post.count}.by -3
      end
    end

    describe 'comments' do
      it 'has comments' do
        expect(user).to respond_to :comments
      end

      it 'destroys comments' do
        create_list :comment, 3, user: user
        expect{
          user.destroy
        }.to change{Comment.count}.by -3
      end
    end

    describe 'location_ownerships' do
      it 'has location_ownerships' do
        expect(user).to respond_to :location_ownerships
      end

      it 'destroys location_ownerships' do
        create_list :location_ownership, 3, user: user
        expect{
          user.destroy
        }.to change{LocationOwnership.count}.by -3
      end
    end

    describe 'wall_comments' do
      it 'has wall_comments' do
        expect(user).to respond_to :wall_comments
      end

      it 'destroys wall_comments' do
        create_list :comment, 3, commentable: user
        expect{
          user.destroy
        }.to change{Comment.count}.by -3
      end
    end

    describe 'curator' do
      it 'has curator' do
        expect(user).to respond_to :curator
      end

      it 'destroys curator' do
        create :curator, user: user
        expect{
          user.destroy
        }.to change{Curator.count}.by -1
      end
    end
  end
end
