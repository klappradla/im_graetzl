require 'rails_helper'

RSpec.describe GraetzlsController, type: :routing do
  describe 'routes' do
    it 'routes /graetzl-slug to #show' do
      expect(get: '/graetzl-slug').to route_to('graetzls#show', id: 'graetzl-slug')
    end
  end

  describe 'named routes' do
    it 'routes graetzl_path to #show' do
      expect(get: graetzl_path('graetzl-slug')).to route_to('graetzls#show', id: 'graetzl-slug')
    end
    it 'routes GET locations_graetzl_path to #locations' do
      expect(get: locations_graetzl_path('graetzl-slug')).to route_to('graetzls#locations', id: 'graetzl-slug')
    end
    it 'routes GET meetings_graetzl_path to #index' do
      expect(get: meetings_graetzl_path('graetzl-slug')).to route_to 'graetzls#meetings', id: 'graetzl-slug'
    end
    it 'routes GET posts_graetzl_path to #posts' do
      expect(get: posts_graetzl_path('graetzl-slug')).to route_to('graetzls#posts', id: 'graetzl-slug')
    end
    it 'routes GET zuckerls_graetzl_path to #index' do
      expect(get: zuckerls_graetzl_path('graetzl-slug')).to route_to('graetzls#zuckerls', id: 'graetzl-slug')
    end
    it 'routes GET groups_graetzl_path to #index' do
      expect(get: groups_graetzl_path('graetzl-slug')).to route_to('graetzls#groups', id: 'graetzl-slug')
    end


  end
end
