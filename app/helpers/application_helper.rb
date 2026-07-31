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
    open_ring = persona.open_to_larp? ? "ring-[3px] ring-[#01754f] ring-offset-1" : ""
    if persona.avatar.attached?
      image_tag url_for(persona.avatar), alt: persona.name,
        class: "shrink-0 rounded-full object-cover select-none #{size_classes} #{'ring-4 ring-white' if ring} #{open_ring} #{classes}"
    else
      style = "background: linear-gradient(135deg, hsl(#{persona.hue}, 46%, 44%), hsl(#{(persona.hue + 35) % 360}, 52%, 28%));"
      content_tag :div, persona.initials,
        class: "shrink-0 rounded-full text-white font-bold flex items-center justify-center select-none " \
               "#{size_classes} #{'ring-4 ring-white' if ring} #{open_ring} #{classes}",
        style: style
    end
  end

  # Where tips land. Swap via TIP_URL env var (Stripe Payment Link, Ko-fi, etc).
  def tip_url
    ENV["TIP_URL"].presence || "https://buymeacoffee.com/joseamroo"
  end

  # Verified Larper: the self-awarded blue check that means nothing.
  def verified_check(persona)
    return unless persona.verified?
    content_tag :span, class: "inline-flex shrink-0", title: "Verified Larper. Self-certified. The most honest verification on the internet." do
      content_tag(:svg, class: "w-3.5 h-3.5 text-cobalt-600", fill: "currentColor", viewBox: "0 0 24 24") do
        raw '<path d="m23 12-2.44-2.79.34-3.69-3.61-.82-1.89-3.2L12 2.96 8.6 1.5 6.71 4.69 3.1 5.5l.34 3.7L1 12l2.44 2.79-.34 3.7 3.61.82L8.6 22.5l3.4-1.47 3.4 1.46 1.89-3.19 3.61-.82-.34-3.69L23 12Zm-12.91 4.72-3.8-3.81 1.48-1.48 2.32 2.33 5.85-5.87 1.48 1.48-7.33 7.35Z"/>'
      end
    end
  end

  # LinkedIn-style gold Premium square next to names.
  def premium_badge(persona)
    return unless persona.premium?
    content_tag :span, "in",
      class: "inline-flex items-center justify-center w-3.5 h-3.5 rounded-[2px] bg-gold-500 text-white text-[9px] font-bold leading-none shrink-0",
      title: "LarpIn Premium. The badge does nothing. That's the point."
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
