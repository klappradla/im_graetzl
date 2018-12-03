ActiveAdmin.register DiscussionDefaultCategory do
  menu parent: 'Gruppe'

  permit_params :title
end
