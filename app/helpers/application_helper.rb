module ApplicationHelper
  AVATAR_SIZES = {
    8 => "w-8 h-8 text-xs",
    10 => "w-10 h-10 text-sm",
    12 => "w-12 h-12 text-base",
    16 => "w-16 h-16 text-xl",
    24 => "w-24 h-24 text-3xl"
  }.freeze

  def avatar_tag(persona, size: 12, ring: false, classes: "")
    size_classes = AVATAR_SIZES.fetch(size, AVATAR_SIZES[12])
    if persona.avatar.attached?
      image_tag url_for(persona.avatar), alt: persona.name,
        class: "shrink-0 rounded-full object-cover select-none #{size_classes} #{'ring-4 ring-white' if ring} #{classes}"
    else
      style = "background: linear-gradient(135deg, hsl(#{persona.hue}, 46%, 44%), hsl(#{(persona.hue + 35) % 360}, 52%, 28%));"
      content_tag :div, persona.initials,
        class: "shrink-0 rounded-full text-white font-bold flex items-center justify-center select-none " \
               "#{size_classes} #{'ring-4 ring-white' if ring} #{classes}",
        style: style
    end
  end

  def cover_tag(persona, height_class)
    if persona.cover.attached?
      image_tag url_for(persona.cover), alt: "", class: "#{height_class} w-full object-cover"
    else
      content_tag :div, nil, class: height_class,
        style: "background: linear-gradient(120deg, hsl(#{persona.hue}, 30%, 30%), hsl(#{(persona.hue + 55) % 360}, 34%, 44%));"
    end
  end

  def post_body_html(text)
    escaped = ERB::Util.html_escape(text.strip).to_str
    escaped.gsub(/(?<=^|[[:space:]])#[[:alpha:]][[:alnum:]_]*/) { |tag| "<span class=\"hashtag\">#{tag}</span>" }.html_safe
  end

  def short_time_ago(time)
    seconds = Time.current - time
    case seconds
    when 0...60 then "now"
    when 60...3600 then "#{(seconds / 60).to_i}m"
    when 3600...86_400 then "#{(seconds / 3600).to_i}h"
    when 86_400...(86_400 * 30) then "#{(seconds / 86_400).to_i}d"
    else "#{(seconds / (86_400 * 30)).to_i}mo"
    end
  end

  def og_description(post)
    text = post.body.presence || "A visual larp."
    truncate(text.gsub(/\s+/, " ").strip, length: 160)
  end
end
