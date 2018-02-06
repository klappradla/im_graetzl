require 'rails_helper'

RSpec.describe LocationPostsController, type: :routing do
  describe 'routes ' do
    it 'routes POST /location_posts to #create' do
      expect(post: '/location_posts').to route_to('location_posts#create')
    end

    it 'routes POST /location_posts/post-slug/comments to #comment' do
      expect(post: '/location_posts/post-slug/comments').to route_to('location_posts#comment', location_post_id: 'post-slug')
    end

  end
  describe 'named routes' do
    it 'routes POST location_posts_path to #create' do
      expect(post: location_posts_path).to route_to('location_posts#create')
    end

    it 'routes POST location_post_comments_path to #comment' do
      expect(post: location_post_comments_path('post-slug')).to route_to('location_posts#comment', location_post_id: 'post-slug')
    end
  end
end
