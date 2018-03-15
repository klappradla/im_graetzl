require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :routing do
  describe 'routes' do
    it 'routes /admin to #index' do
      expect(get: '/admin').to route_to('admin/dashboard#index')
    end
  end
  describe 'named routes' do
    it 'routes admin_root to #index' do
      expect(get: admin_root_path).to route_to('admin/dashboard#index')
    end
  end
end
