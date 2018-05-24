module ApplicationHelper

  def language_changer
    if I18n.locale == :hu
      link_to(image_tag("en_flag.png", alt: "English"), { :locale=>'en' })
    elsif I18n.locale == :en
      link_to(image_tag("hu_flag.png", alt: "Magyar"), { :locale=>'hu' })
    end
  end

  def sortable(column, title = nil)
    # If we don't receive a title for the column header we create one out of the field name:
    title ||= column.titleize
    # The direction will be set to  ascending
    # except when this column is already the sort_column and is currently set to ascending
    direction = (column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc')
    link_to title, {:sort => column, :direction => direction}
  end

  def generate_qr(text)
    require 'barby'
    require 'barby/qr_code'
    require 'barby/outputter/png_outputter'

    barcode = Barby::QrCode.new(text, level: :q, size: 5)
    base64_output = Base64.encode64(barcode.to_png({ xdim: 5 }))
    return "data:image/png;base64,#{base64_output}"
  end

end
