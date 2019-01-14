require 'rails_helper'
include GeojsonSupport
include Stubs::AddressApi

RSpec.describe LocationsController, type: :controller do
  before { stub_address_api! }

  describe 'GET index' do
    let!(:graetzl) { create :graetzl }
    let!(:old_locations) { create_list :location, 15, :approved, graetzl: graetzl }
    let!(:new_locations) { create_list :location, 15, :approved, graetzl: graetzl }

    context 'when js request for more locations' do
      before { get :index, params: { graetzl_id: graetzl, page: 2 }, xhr: true }

      it 'assigns older 15 @locations' do
        expect(assigns :locations).to match_array old_locations
      end
      it 'renders index.js' do
        expect(response.content_type).to eq 'text/javascript'
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET show' do
    let(:graetzl) { create :graetzl }
    context 'when location :approved' do
      let(:location) { create :location, :approved, graetzl: graetzl }
      let!(:old_location_posts) { create_list :location_post, 10, author: location, graetzl: graetzl }
      let!(:new_location_posts) { create_list :location_post, 10, author: location, graetzl: graetzl }
      let!(:new_meetings) { create_list :meeting, 2, location: location, starts_at_date: Date.tomorrow }
      let!(:old_meetings) { create_list :meeting, 2, location: location, starts_at_date: nil }

      context 'when html request' do
        before { get :show, params: { graetzl_id: graetzl, id: location } }

        it 'assigns @graetzl' do
          expect(assigns :graetzl).to eq graetzl
        end
        it 'assigns @location' do
          expect(assigns :location).to eq location
        end
        it 'assigns 10 new @posts' do
          expect(assigns :posts).to match_array(new_location_posts + old_location_posts)
        end
        it 'assigns @zuckerls' do
          expect(assigns :zuckerls).to be
        end
        it 'renders show.html' do
          expect(response.content_type).to eq 'text/html'
          expect(response).to render_template(:show)
        end
      end
    end

    context 'when location not approved' do
      let(:location) { create :location, :pending, graetzl: graetzl }

      it 'redirect_to root' do
        get :show, params: { graetzl_id: graetzl, id: location }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET new' do
    context 'when logged out' do
      it 'redirects to login with flash' do
        get :new
        expect(response).to redirect_to new_user_session_path
        expect(flash[:alert]).to be_present
      end
    end
    context 'when logged in' do
      let(:graetzl) { create :graetzl }
      let(:other_graetzl) { create :graetzl }
      let!(:district) { create :district, graetzls: [graetzl, other_graetzl] }
      let(:user) { create :user, graetzl: graetzl }

      before { sign_in user }

      context 'without graetzl_id param' do
        before { get :new }

        it 'assigns @graetzl with user.graetzl' do
          expect(assigns :graetzl).to eq graetzl
        end
        it 'assigns @district' do
          expect(assigns :district).to eq district
        end
        it 'renders :graetzl_form' do
          expect(response).to render_template :graetzl_form
        end
      end
      context 'with graetzl_id param' do
        before { get :new, params: { graetzl_id: other_graetzl.id } }

        it 'assigns @graetzl with other_graetzl' do
          expect(assigns :graetzl).to eq other_graetzl
        end
        it 'assigns @district' do
          expect(assigns :district).to eq district
        end
        it 'renders :graetzl_form' do
          expect(response).to render_template :graetzl_form
        end
      end
    end
  end

  describe 'POST new' do
    context 'when logged out' do
      it 'redirects to login with flash' do
        post :new
        expect(response).to redirect_to new_user_session_path
        expect(flash[:alert]).to be_present
      end
    end
    context 'when logged in' do
      let(:graetzl) { create(:graetzl) }
      let(:user) { create(:user) }

      before do
        sign_in user
        post :new, params: { graetzl_id: graetzl.id }
      end

      it 'assigns @graetzl' do
        expect(assigns :graetzl).to eq graetzl
      end
      it 'assigns @location' do
        expect(assigns :location).to be_a_new Location
      end
      it 'renders :new' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST create' do
    context 'when logged out' do
      it 'redirects to login' do
        post :create
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when logged in' do
      let(:user) { create :user }
      let(:graetzl) { create :graetzl }

      before { sign_in user }

      context 'with valid attributes' do
        let!(:category) { create :category, context: Category.contexts[:business] }
        let(:attrs) { attributes_for :location }
        let(:params) { { location: {
          graetzl_id: graetzl.id,
          name: attrs[:name],
          location_type: attrs[:location_type],
          slogan: attrs[:slogan],
          description: attrs[:description],
          category_id: category.id }}}

        context 'with basic attributes' do
          it 'creates location record' do
            expect{
              post :create, params: params
            }.to change{Location.count}.by 1
          end

          it 'creates location_ownership record' do
            expect{
              post :create, params: params
            }.to change{LocationOwnership.count}.by 1
          end

          it 'does not create category record' do
            expect{
              post :create, params: params
            }.not_to change{Category.count}
          end

          it 'assigns @location' do
            post :create, params: params
            expect(assigns :location).to have_attributes(
              state: 'pending',
              graetzl: graetzl,
              name: attrs[:name],
              category: category,
              slogan: attrs[:slogan],
              description: attrs[:description],
              user_ids: [user.id])
          end

          it 'redirects to root with notice' do
            post :create, params: params
            expect(response).to redirect_to root_url
            expect(flash[:notice]).to be_present
          end
        end

        describe 'with contact and address' do
          let(:address) { build(:address) }
          let(:contact) { build(:contact) }

          before do
            params[:location].merge!(contact_attributes: {
              website: contact.website,
              email: contact.email,
              phone: contact.phone })
            params[:location].merge!(address_attributes: {
              street_name: address.street_name,
              street_number: address.street_number,
              zip: address.zip,
              city: address.city})
          end

          it 'creates new address record' do
            expect{
              post :create, params: params
            }.to change{Address.count}.by 1
          end
          it 'creates new contact record' do
            expect{
              post :create, params: params
            }.to change{Contact.count}.by 1
          end
        end
      end
      context 'with invalid attributes' do
        it 'renders :new' do
          post :create, params: { location: { graetzl_id: graetzl.id } }
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'GET edit' do
    let(:location) { create :location }

    context 'when logged out' do
      it 'redirects to login with flash' do
        get :edit, params: { id: location }
        expect(response).to redirect_to new_user_session_path
        expect(flash[:alert]).to be_present
      end
    end
    context 'when logged in' do
      let(:user) { create(:user) }
      before { sign_in user }

      context 'when owner of location' do
        before do
          create :location_ownership, user: user, location: location
          get :edit, params: { id: location }
        end

        it 'assigns @location' do
          expect(assigns :location).to eq location
        end
        it 'renders :edit' do
          expect(response).to render_template :edit
        end
      end
      context 'when not owner' do
        it 'returns 404' do
          expect{
            get :edit, params: { id: location }
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end

  describe 'PUT update' do
    let(:location) { create :location, contact: create(:contact), address: create(:address), category: create(:category) }

    context 'when logged out' do
      it 'redirects to login' do
        put :update, params: { id: location }
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when logged in' do
      let(:user) { create :user }
      let(:attrs) { attributes_for :location, meeting_permission: 'non_meetable' }
      let(:params) {{ id: location, location: {
        name: attrs[:name],
        slogan: attrs[:slogan],
        description: attrs[:description],
        meeting_permission: attrs[:meeting_permission] }}}

      before { sign_in user }

      context 'when not owner' do
        it 'returns 404' do
          expect{
            put :update, params: params
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context 'when owner' do
        before { create :location_ownership, user: user, location: location }

        describe 'change basic attributes' do
          before do
            put :update, params: params
            location.reload
          end

          it 'assigns @location' do
            expect(assigns :location).to eq location
          end
          it 'updates attributes' do
            expect(location).to have_attributes(
              name: attrs[:name],
              slogan: attrs[:slogan],
              description: attrs[:description],
              meeting_permission: attrs[:meeting_permission])
          end
          it 'redirect_to location in graetzl' do
            expect(response).to redirect_to [location.graetzl, location]
          end
        end
        describe 'change contact, category and address' do
          let(:address) { build(:address) }
          let(:contact) { build(:contact) }
          let(:category) { create(:category) }

          before do
            params[:location].merge!(category_id: category.id)
            params[:location].merge!(contact_attributes: {
              id: location.contact.id,
              website: contact.website,
              email: contact.email,
              phone: contact.phone })
            params[:location].merge!(address_attributes: {
              id: location.address.id,
              street_name: address.street_name,
              street_number: address.street_number,
              zip: address.zip,
              city: address.city,
              coordinates: address.coordinates })
            put :update, params: params
            location.reload
          end

          it 'updates contact' do
            expect(location.contact).to have_attributes(
              website: contact.website,
              email: contact.email,
              phone: contact.phone)
          end
          it 'updates address' do
            expect(location.address).to have_attributes(
              street_name: address.street_name,
              street_number: address.street_number,
              zip: address.zip,
              city: address.city)
          end
          it 'updates category' do
            expect(location.location_category).to eq category
          end
        end
        describe 'remove address' do
          before { params[:location].merge!(address_attributes: { id: location.address.id, _destroy: 1 }) }

          it 'removes address from location' do
            expect{
              put :update, params: params
              location.reload
            }.to change{location.address}.to nil
          end
          it 'deletes address record' do
            expect{
              put :update, params: params
            }.to change{Address.count}.by -1
          end
        end
        describe 'change graetzl' do
          let(:new_graetzl) { create(:graetzl) }

          before { params[:location].merge!(graetzl_id: new_graetzl.id) }

          it 'updates graetzl' do
            expect{
              put :update, params: params
              location.reload
            }.to change{location.graetzl}.to new_graetzl
          end
        end
      end
    end
  end

  describe 'DELETE destroy' do
    let(:location) { create :location }

    context 'when logged out' do
      it 'redirects to login' do
        delete :destroy, params: { id: location }
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when logged in' do
      let(:user) { create :user }
      before { sign_in user }

      context 'when not owner' do
        it 'returns 404' do
          expect{
            delete :destroy, params: { id: location }
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end
      context 'when owner' do
        before { create :location_ownership, user: user, location: location }

        it 'assigns @location' do
          delete :destroy, params: { id: location }
          expect(assigns :location).to eq location
        end
        it 'deletes location record' do
          expect{
            delete :destroy, params: { id: location }
          }.to change{Location.count}.by -1
        end
        it 'redirects to locations_user_path' do
          delete :destroy, params: { id: location }
          expect(response).to redirect_to locations_user_path
        end
      end
    end
  end
end
