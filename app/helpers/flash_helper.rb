module FlashHelper
  def flash_message_colors(type)
    case type.to_sym
    when :alert
      "text-white shadow-slate-600 bg-pink-700"
    else
      "text-white shadow-slate-600 bg-emerald-700"
    end
  end

  def flash_icon_colors(type)
    case type.to_sym
    when :alert
      [ "text-white", "text-pink-800" ]
    else
      [ "text-white", "text-emerald-800" ]
    end
  end

  def flash_icon(type)
    case type.to_sym
    when :alert
      "radiation"
    else
      "thumbs-up"
    end
  end
end
