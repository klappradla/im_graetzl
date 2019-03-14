ActiveAdmin.register AdminPost do
  menu parent: 'Posts'
  before_create do |admin_post|
    admin_post.author = current_user
  end
  after_create do |admin_post|
    admin_post.create_activity :create, owner: current_user
  end

  filter :author_id, as: :select, collection: -> { User.admin }
  filter :title
  filter :content
  filter :created_at

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  permit_params :title,
    :content,
    graetzl_ids: [],
    images_attributes: [:id, :file, :_destroy]
end
