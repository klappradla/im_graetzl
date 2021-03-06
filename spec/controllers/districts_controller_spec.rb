require 'rails_helper'

RSpec.describe DistrictsController, type: :controller do
  render_views

  describe 'GET show' do
    let(:district) { create :district }

    before { get :show, params: { id: district } }

    it 'assigns @district' do
      expect(assigns :district).to eq district
    end

    it 'assigns @map_data' do
      expect(assigns :map_data).to be
    end

    it 'assigns @activity_sample' do
      expect(assigns :activity_sample).to be
    end

    it 'renders #show' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET graetzls' do
    let!(:graetzl_1) { create(:graetzl) }
    let!(:graetzl_2) { create(:graetzl) }
    let(:district) { create(:district, graetzls: [graetzl_1, graetzl_2])}

    before { get :graetzls, params: { id: district, format: :json } }

    it 'assigns @district' do
      expect(assigns(:district)).to eq district
    end

    it 'responds with json' do
      expect(response.content_type).to eq('application/json')
    end

    it 'returns id and name of each graetzl' do
      graetzls = JSON.parse(response.body)
      expect(graetzls).to include({'id' => graetzl_1.id, 'name' => graetzl_1.name},
                                  {'id' => graetzl_2.id, 'name' => graetzl_2.name})
    end
  end
end
