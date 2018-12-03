module ApplicationHelper
  def main_navigation(mobile=nil)
    case
    when @district
      render "nav_district#{'_mobile' if mobile}", district: @district
    when @graetzl || current_user.try(:graetzl)
      render "nav_graetzl#{'_mobile' if mobile}", graetzl: (@graetzl || current_user.graetzl)
    else
      render "nav_home#{'_mobile' if mobile}"
    end
  end

  def personal_navigation_for(user)
    render user ? 'nav_user' : 'nav_guest'
  end

  def link_to_more_info
    blog_url = 'http://blog.imgraetzl.at/services/'
    icon = 'icon-lightbulb'
    use = content_tag(:use, nil, { 'xlink:href' => "##{icon}" })
    link_to blog_url, target: '_blank' do
      concat content_tag(:svg, use, class: icon)
      concat "Mehr Infos"
    end
  end

  def active_link_to(*args, &block)
    if block_given?
      name = capture(&block)
      options = args[0] || {}
      html_options = args[1] || {}
    else
      name = args[0]
      options = args[1] || {}
      html_options = args[2] || {}
    end

    url = url_for(options)
    html_options[:class] = ['active', html_options[:class]] if current_page?(url)
    link_to(name, url, html_options)
  end

  def graetzl_flag(graetzl)
    content_tag(:div, link_to(graetzl.name, [graetzl]), class: 'graetzl-sideflag sideflag -R')
  end

  def form_errors_for(target, name=nil)
    if target.errors.any?
      name ||= target.model_name.human
      render('errors', target: target, name: name)
    end
  end

  def icon_tag(name)
    "<svg class='icon-#{name}'><use xlink:href='#icon-#{name}'></use></svg>".html_safe
  end

end
