class AddMailchimpIdToBusinessInterests < ActiveRecord::Migration[5.0]
  def change
    add_column :business_interests, :mailchimp_id, :string
  end
end
