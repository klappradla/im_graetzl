class PostsController < ApplicationController

  def index
    head :ok and return if browser.bot? && !request.format.js?
    @posts = collection_scope.includes(:author).order(created_at: :desc)
    @posts = @posts.page(params[:page]).per(15)
  end

  private

  def collection_scope
    if params[:graetzl_id]
      graetzl = Graetzl.find(params[:graetzl_id])
      Post.where("(id IN (:posts)) OR (id IN (:admin_posts))",
        posts: graetzl.posts.where(type: 'UserPost').ids,
        admin_posts: graetzl.admin_posts.ids
      )
    else
      Post.all
    end
  end
end
