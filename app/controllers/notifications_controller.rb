class NotificationsController < ApplicationController
  before_action :authenticate_user!

  NOTIFICATIONS_PER_PAGE = 6

  def unseen_count
    render json: { count: current_user.new_website_notifications_count }
  end

  def fetch
    @notifications = current_user.website_notifications.order("notifications.created_at DESC")
    @notifications.update_all(seen: true)
    @notifications = @notifications.page(params[:page]).per(NOTIFICATIONS_PER_PAGE)
  end

end
