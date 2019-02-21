ActiveAdmin.register DiscussionDefaultCategory do
  menu parent: 'Gruppe', priority: 3

  permit_params :title
end
