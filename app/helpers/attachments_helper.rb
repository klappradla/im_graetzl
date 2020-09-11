module AttachmentsHelper
  def avatar_for(resource, size=200, form=nil)
    if form.nil?
      css_class = resource.is_a?(User) || resource.is_a?(RoomOffer) || resource.is_a?(RoomDemand) ? 'img-round' : 'img-square'
    else
      css_class = form
    end
    if resource.nil?
      fallback = "http://via.placeholder.com/200x200"
    else
      fallback = "avatar/#{resource.model_name.human.downcase}/200x200.png"
    end
    attachment_image_tag(resource, :avatar, :fill, size, size, class: css_class, fallback: fallback)
  end

  # User Avatar with Tooltip
  def user_tooltip_avatar(user, size=200, css=nil)
    if css.nil?
      css_class = 'img-round user-tooltip-trigger'
    else
      css_class = css
    end
    fallback = "avatar/user/200x200.png"
    tooltip_id = "user-tooltip-#{user.id}-#{rand(1000)}"
    tooltip_url = "/user/tooltip?id=#{user.id}"
    attachment_image_tag(user, :avatar, :fill, size, size, class: css_class, fallback: fallback, data: { tooltip_id: tooltip_id, url: tooltip_url })
  end

  def cover_photo_for(resource)
    attachment_image_tag(resource, :cover_photo, :fill, 600, 440, class: 'coverImg', fallback: 'cover_photo/300x180.png')
  end

  def category_photo_for(resource)
    attachment_image_tag(resource, :main_photo, :fill, 400, 600, class: 'categoryImg', fallback: 'cover_photo/200x200.png')
  end
end
