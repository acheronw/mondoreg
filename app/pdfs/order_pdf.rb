class OrderPdf < Prawn::Document
  def initialize(order)
    super(top_margin: 70)

    self.font_families.update("Verdana" => {
        :normal => Rails.root.join("vendor/assets/fonts/verdana.ttf"),
        :italic => Rails.root.join("vendor/assets/fonts/verdanai.ttf"),
        :bold => Rails.root.join("vendor/assets/fonts/verdanab.ttf"),
        :bold_italic => Rails.root.join("vendor/assets/fonts/verdanaz.ttf")
    })
    font "Verdana"


    @order = order
    text "#{@order.id}. számú megrendelés", size: 24, style: :bold
    move_down 20
    text I18n.t('webshop.order.user_name') + @order.user.name.to_s
    text I18n.t('webshop.order.submitted_date') + order.date_submitted.to_s
    # text "Árvíztűrő tükörfúrógép"

    move_down 10
    text I18n.t('webshop.address.title'), style: :bold
    text I18n.t('webshop.address.name') + ": "+ @order.delivery_address.name
    text I18n.t('webshop.address.city') + ": "+ @order.delivery_address.city
    text I18n.t('webshop.address.zip') + ": "+ @order.delivery_address.zip
    text I18n.t('webshop.address.street_address') + ": "+ @order.delivery_address.street_address
    text I18n.t('webshop.address.phone') + ": "+ @order.delivery_address.phone


    move_down 20
    table line_items do
      row(0).font_style = :bold
      columns(1..3).align = :right
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
    move_down 20
    text "Összesen: #{@order.total_price.to_s} Ft", style: :bold

  end




  def line_items
    [['Termék', 'Darabszám', 'Termék ára', 'Tétel ára']] +
    @order.line_items.map do |item|
      [item.product.name, item.quantity.to_s, item.product.price.to_s, (item.product.price * item.quantity).to_s]
    end

  end







end