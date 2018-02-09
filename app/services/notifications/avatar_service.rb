class Notifications::AvatarService
  def initialize(owner)
    @owner = owner
  end

  def call
    refile_img || fallback_img
  end

  private

  attr_reader :owner, :type

  def refile_img
    Refile.attachment_url(@owner, :avatar, :fill, 200, 200, host: host)
  end

  def fallback_img
    type = ActiveModel::Naming.singular @owner
    path = "avatar/#{type}/200x200.png"
    ApplicationController.helpers.image_url(path, host: host)
  end

  def host
    base = Refile.cdn_host || default_host
    URI::HTTP.build(host: base).to_s
  end

  def default_host
    Rails.application.config.action_mailer.default_url_options[:host]
  end
end
