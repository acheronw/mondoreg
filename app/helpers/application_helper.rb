module ApplicationHelper

  def language_changer
    if I18n.locale == :hu
      link_to(image_tag("en_flag.png", alt: "English"), { :locale=>'en' })
    elsif I18n.locale == :en
      link_to(image_tag("hu_flag.png", alt: "Magyar"), { :locale=>'hu' })
    end
  end


end
