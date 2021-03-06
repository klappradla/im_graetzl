class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  # GET /users/registrierung
  def new
    if params[:graetzl_id].blank?
      render "address_form" and return
    end

    build_resource(origin: params[:origin])
    self.resource.graetzl = Graetzl.find(params[:graetzl_id])
    self.resource.address = Address.from_feature(params[:feature])
    respond_with self.resource
  end

  def set_address
    @address = Address.from_feature(params[:feature])
    @graetzls = @address ? @address.graetzls : []

    if @graetzls.size == 1
      redirect_to new_registration_url(
        graetzl_id: @graetzls.first.id,
        feature: params[:feature],
        origin: params[:origin],
        redirect: params[:redirect],
      )
    else
      render "graetzls"
    end
  end

  def graetzls
  end

  def create
    session[:confirmation_redirect] = params[:redirect] if params[:redirect].present?
    super
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    params[:redirect] || root_url
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(
        :username,
        :first_name, :last_name,
        :email,
        :password,
        :business,
        :terms_and_conditions,
        :newsletter,
        :origin,
        :avatar, :remove_avatar,
        :graetzl_id,
        :location_category_id,
        business_interest_ids: [],
        address_attributes: [
          :street_name,
          :street_number,
          :zip,
          :city,
          :coordinates])
    end
  end

end
