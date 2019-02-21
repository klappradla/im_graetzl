context.instance_eval do
  panel 'Gruppen Beitritts Anfrage' do
    attributes_table_for group_join_request do
      row :id
      row :status
      row :user
      row :group
      row :created_at
      row :updated_at
      row :request_message
    end
  end
end
