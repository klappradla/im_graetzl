class UserMessage < ApplicationRecord
  belongs_to :user
  belongs_to :user_message_thread

  after_create :update_thread

  private

  def update_thread
    user_message_thread.update(last_message: message, last_message_at: created_at)
  end
end
