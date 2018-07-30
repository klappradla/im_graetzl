class CreateDiscussionFollowing < ActiveRecord::Migration[5.0]

  def change
    create_table :discussion_followings do |t|
      t.references :discussion, foreign_key: { on_delete: :cascade }, index: true
      t.references :user, foreign_key: { on_delete: :cascade }, index: true
      t.timestamps
    end
  end

end
