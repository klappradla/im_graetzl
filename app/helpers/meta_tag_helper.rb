module MetaTagHelper
  META_TAGS = [:description, :robots]
  OG_TAGS = [:title, :description, :image]

  def title(page_title)
    content_for(:title) { "#{page_title} | "}
  end

  def canonical_tag
    url = "https://#{request.host + request.fullpath}"
          .gsub(/\/$/, "")
          .gsub(/scope=.+&/, "")
    tag(:link, rel: 'canonical', href: url)
  end

  def meta(tags_hash)
    tags_hash.each do |tag, content|
      case
      when tag == :title
        title(content)
      when tag =~ /og_/
        og_tag(tag[3..-1], content)
      else
        meta_tag(tag, content)
      end
    end
  end

  private

  def meta_tag(name, content)
    content_for :"meta_#{name}" do
      tag(:meta, name: name.to_s, content: content)
    end
  end

  def og_tag(name, content)
    content_for :"og_#{name}" do
      tag(:meta, property: "og:#{name}", content: content)
    end
  end
end
