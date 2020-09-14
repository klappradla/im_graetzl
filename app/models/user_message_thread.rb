class UserMessageThread < ApplicationRecord
  has_many :user_message_thread_members
  has_many :users, through: :user_message_thread_members
  has_many :user_messages

  belongs_to :tool_rental, optional: true
  belongs_to :room_rental, optional: true

  enum thread_type: { general: 0, room_rental: 1, tool_rental: 2 }

  before_create :set_last_message_at

  attr_accessor :status

  def self.create_for_room_rental(room_rental)
    thread = find_by(room_rental_id: room_rental.id)
    return thread if thread
    thread = create(room_rental: room_rental, thread_type: :room_rental)
    thread.users << room_rental.renter
    thread.users << room_rental.owner
    thread
  end

  def self.create_for_tool_rental(tool_rental)
    thread = find_by(tool_rental_id: room_rental.id)
    return thread if thread
    thread = create(tool_rental: tool_rental, thread_type: :tool_rental)
    thread.users << tool_rental.renter
    thread.users << tool_rental.owner
    thread
  end

  def self.create_general(*users)
    user_key = users.map(&:id).sort.join(":")
    thread = find_by(user_key: user_key)
    return thread if thread
    thread = create(user_key: user_key, thread_type: :general)
    thread.users = users
    thread
  end

  private

  def set_last_message_at
    self.last_message_at = Time.current
  end
end
