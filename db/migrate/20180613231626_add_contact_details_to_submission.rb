class AddContactDetailsToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :room_call_submissions, :first_name, :string
    add_column :room_call_submissions, :last_name, :string
    add_column :room_call_submissions, :email, :string
    add_column :room_call_submissions, :phone, :string
    add_column :room_call_submissions, :website, :string
  end
end
