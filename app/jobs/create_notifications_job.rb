class CreateNotificationsJob < ApplicationJob

  def perform(activity)
    ActiveRecord::Base.connection_pool.with_connection do
      #puts '----CreateNotificationsJob-----'
      #puts activity
      Notification.broadcast(activity)
    end
  end
end
