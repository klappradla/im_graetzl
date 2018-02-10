class Activity < ApplicationRecord
  belongs_to :trackable, polymorphic: true
  belongs_to :owner, optional: true, class_name: "User"
  belongs_to :recipient, polymorphic: true
  serialize :parameters, Hash

  after_commit on: :create do |activity|
    Notification.receive_new_activity(activity)
  end

  before_destroy :destroy_notifications, prepend: true

  def appendix
    if key == 'location.create'
      { message: { title: "Neu auf imGrätzl", content: "Sag gleich Hallo!"}}
    elsif key.end_with?('.comment')
      { comment: trackable.comments.last }
    elsif key.end_with?('.go_to')
      { participant: owner }
    else
      {}
    end
  end

  private

  def destroy_notifications
    Notification.where(activity: self).destroy_all
  end
end
