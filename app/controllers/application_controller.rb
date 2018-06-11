class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # hide staging app from public
  http_basic_authenticate_with name: 'user', password: 'secret' if Rails.env.staging? && !(ENV["ALLOW_WORKER"] == 'true')

  force_ssl if Rails.env.staging? || Rails.env.production?

  def after_sign_in_path_for(resource)
    params[:redirect] || graetzl_path(resource.graetzl)
  end

  def authenticate_admin_user!
    authenticate_user!
    unless current_user.admin?
      flash[:alert] = 'Keine Admin Rechte.'
      redirect_to root_path
    end
  end
end
