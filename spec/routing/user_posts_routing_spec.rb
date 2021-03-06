require 'rails_helper'

RSpec.describe UserPostsController, type: :routing do
  describe 'routes ' do
    it 'routes GET graetzl-slug/ideen/post-slug to #show' do
      expect(get: 'graetzl-slug/ideen/post-slug').to route_to('user_posts#show', graetzl_id: 'graetzl-slug', id: 'post-slug')
    end

    it 'routes GET graetzl-slug/ideen/new to #new' do
      expect(get: 'graetzl-slug/ideen/new').to route_to('user_posts#new', graetzl_id: 'graetzl-slug')
    end

    it 'routes POST graetzl-slug/ideen to #create' do
      expect(post: 'graetzl-slug/ideen').to route_to('user_posts#create', graetzl_id: 'graetzl-slug')
    end
  end
  describe 'named routes' do
    it 'routes GET graetzl_user_post_path to #show' do
      expect(get: graetzl_user_post_path('graetzl-slug', 'post-slug')).to route_to('user_posts#show', graetzl_id: 'graetzl-slug', id: 'post-slug')
    end

    it 'routes GET new_graetzl_user_post_path to #new' do
      expect(get: new_graetzl_user_post_path('graetzl-slug')).to route_to('user_posts#new', graetzl_id: 'graetzl-slug')
    end

    it 'routes POST graetzl_user_posts_path to #create' do
      expect(post: graetzl_user_posts_path('graetzl-slug')).to route_to('user_posts#create', graetzl_id: 'graetzl-slug')
    end
  end
end
