class Notifications::ImageService

  def avatar_url(owner)
    if owner.avatar
      Refile.attachment_url(owner, :avatar, :fill, 200, 200, host: host)
    else
      path = "avatar/#{ActiveModel::Naming.singular(owner)}/200x200.png"
      ApplicationController.helpers.image_url(path, host: host)
    end
  end

  def cover_photo_url(owner)
    if owner.cover_photo
      Refile.attachment_url(owner, :cover_photo, :fill, 600, 300, host: host)
    else
      path = "cover_photo/600x300.png"
      ApplicationController.helpers.image_url(path, host: host)
    end
  end

  private

  def host
    base = Refile.cdn_host || default_host
    URI::HTTP.build(host: base).to_s
  end

  def default_host
    Rails.application.config.action_mailer.default_url_options[:host]
  end
end
