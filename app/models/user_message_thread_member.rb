class UserMessageThreadMember < ApplicationRecord
  belongs_to :user
  belongs_to :user_message_thread

  enum status: { active: 0, archived: 1, deleted: 2 }
end
