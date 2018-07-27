context.instance_eval do
  panel 'Basic Details' do
    attributes_table_for group do
      row :id
      row :title
      row :description
      row :room_offer
      row :room_call
      row :private
      row :created_at
      row :updated_at
    end
  end

  panel "Users" do
    table_for group.group_users do
      column :user
      column("Email") { |f| f.user.email }
      column :role
    end
  end
end
