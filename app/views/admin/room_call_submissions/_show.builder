context.instance_eval do
  panel 'Basic Details' do
    attributes_table_for room_call_submission do
      row :id
      row :room_call
      row :user
      row :first_name
      row :last_name
      row :email
      row :phone
      row :website
      row :created_at
      row :updated_at
    end
  end
  panel "Fields" do
    table_for room_call_submission.room_call_submission_fields do
      column "Question" do |field|
        field.room_call_field.label
      end
      column :content
    end
  end
end
