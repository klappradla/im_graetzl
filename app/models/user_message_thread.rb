class UserMessageThread < ApplicationRecord
  has_many :user_message_thread_members
  has_many :users, through: :user_message_thread_members
  has_many :user_messages

  belongs_to :tool_rental, optional: true

  before_create :set_last_message_at

  attr_accessor :status

  def self.create_for_tool_rental(tool_rental)
    thread = create(tool_rental: tool_rental)
    thread.users << tool_rental.renter
    thread.users << tool_rental.owner
    thread
  end

  private

  def set_last_message_at
    self.last_message_at = Time.current
  end
end
