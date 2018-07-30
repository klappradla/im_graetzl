class NotificationSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_valid_type

  def toggle_website_notification
    notification_type = params[:type].constantize
    current_user.toggle_website_notification(notification_type)
    render json: :ok
  end

  def change_mail_notification
    notification_type = params[:type].constantize

    if params[:interval] == 'off'
      current_user.disable_all_mail_notifications(notification_type)
    else
      current_user.enable_mail_notification(notification_type, params[:interval].to_sym)
    end
    render json: :ok
  end

  private

  def check_valid_type
    if !Notification.subclasses.map(&:name).include?(params[:type])
      render body: "unrecognized type: #{params[:type]}", status: :forbidden
    end
  end

end
