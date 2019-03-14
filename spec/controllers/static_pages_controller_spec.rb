require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe 'GET home' do
    context 'when logged in' do
      let(:user) { create(:user) }
      before do
        sign_in user
        get :home
      end

      it 'redirect_to user.graetzl' do
        expect(response).to redirect_to(user.graetzl)
      end
    end

    context 'when logged out' do
      before { get :home }

      it 'renders #home' do
        expect(response).to render_template(:home)
      end

      it 'assigns @activity_sample' do
        expect(assigns(:activity_sample)).to be
      end

      describe '@meetings' do
        subject(:activity_sample) { assigns(:activity_sample) }
        context 'without meetings' do

          it 'is empty' do
            get :home
            expect(activity_sample.meetings).to be_empty
          end
        end

        context 'with meetings' do
          let(:past_meeting) { build(:meeting, starts_at_date: Date.yesterday) }
          let!(:upcoming_meeting) { create(:meeting, starts_at_date: Date.tomorrow) }
          before do
            past_meeting.save(validate: false)
            get :home
          end

          it 'contains 2 upcoming meetings' do
            expect(activity_sample.meetings).to contain_exactly(upcoming_meeting, past_meeting)
          end
        end
      end
    end
  end
end
