class Users::SessionsController < Devise::SessionsController
before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new

    # Set OriginPath for User Regsitration
    if request.referer && URI(request.referer).host == request.host
      @origin_path_from_referer = URI(request.referer).path
    else
      @origin_path_from_referer = request.path
    end

    super
   end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected
    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.for(:sign_in) << :attribute
    # end

    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in) do |u|
        u.permit(:login, :username, :email, :password, :remember_me)
      end
    end
end
