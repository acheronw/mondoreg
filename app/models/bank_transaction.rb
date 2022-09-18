class BankTransaction < ApplicationRecord
  validates :csv_line, uniqueness: true

  scope :requires_human, -> {where(status: ['pending', 'problematic'])}

  def self.import(file)
    successful_counter = 0
    resolved_counter = 0
    duplicate_counter = 0
    duplicates = []
    CSV.foreach(file.path, {headers: true,
                            encoding: 'windows-1250:utf-8',
                            col_sep: ';'    }) do | row |
      if row["Terhelés vagy jóváírás (T/J)"] == "J"
        bt = BankTransaction.new
        bt.csv_line = row.to_s
        bt.date_of_transaction = row["Könyvelés dátuma"]
        bt.amount_of_transaction = row["Összeg"].to_i
        bt.comment_of_transaction = row["Közlemény"] || ""
        bt.sender_of_transaction= row["Partner neve"]
        mc_code_match = /mc[[:digit:]]+/.match(bt.comment_of_transaction.downcase)
        # If we have a match we get the string, and remove the opening 'mc' characters:
        bt.order_id_code = mc_code_match[0][2 .. -1] if mc_code_match
        # We set everything to pending at this point. We do proper processing after a successful save.
        bt.status = "pending"
        if bt.save
          successful_counter += 1
          resolved_counter += 1 if bt.match_transaction_to_order
        else
          duplicates << bt.csv_line
          duplicate_counter += 1
        end
      end
    end

    message = "SIKERESEN beimportáltunk #{successful_counter} befizetést. Ebből #{resolved_counter}-et fel is dolgoztunk."
    if duplicate_counter > 0
      message += "|\tDUPLIKÁTUMOK, amiket nem importáltunk be: #{duplicate_counter}"
      message += "|\tLegelső duplikátum: #{duplicates.first}\t|\tLegutolsó duplikátum: #{duplicates.last}"
    end

    return message
  end

  def match_transaction_to_order
    successful_match = false
    if self.order_id_code
      ticket_order = TicketOrder.find_by(id: self.order_id_code)
      if ticket_order
        if ticket_order.total_price != self.amount_of_transaction
          # The money did not add up
          self.problem= "Az összeg nem egyezik, a lefoglalt jegyek ára: #{ticket_order.total_price}"
          self.status= 'problematic'
        elsif ticket_order.status != 'pending'
          # This order was already paid
          self.problem= "Ez a rendelés már korábban ki lett fizetve"
          self.status= 'problematic'
        elsif ticket_order.ticket.sale_end.tomorrow < self.date_of_transaction
          self.problem= "Határidő utáni befizetés"
          self.status= 'problematic'
        else
          ticket_order.confirm('bank_transaction')
          self.status='done'
          successful_match = true
        end
      else
        # There was an order_id in the transaction comments but there is no such id in the database.
        self.problem= "Az adatbázisban nincs ilyen azonosítóval rendelés: #{self.order_id_code}"
        self.status= 'problematic'
      end
    elsif self.sender_of_transaction.blank?
      # We couldn't identify the order by the comment and the name is missing as well.
      self.problem= "Üres a befizető neve és a megjegyzés alapján se tudtuk beazonosítani."
      self.status= 'problematic'
    else
      # Transaction missing order ID.
      users_matching_sender = User.where('lower(name) = ?', self.sender_of_transaction.mb_chars.downcase.to_s).all

      if users_matching_sender.length == 1
        ticket_orders = TicketOrder.where(user: users_matching_sender.first).requires_attention.all.to_a
        ticket_orders.delete_if { |ticket_order| ticket_order.status != 'pending' }
        ticket_orders.delete_if { |ticket_order| ticket_order.total_price != self.amount_of_transaction }
        ticket_orders.delete_if { |ticket_order| ticket_order.ticket.sale_end.tomorrow < self.date_of_transaction }
        if ticket_orders.length == 1
          # We have exactly one matching ticket order
          ticket_orders.first.confirm
          self.status ='done'
          successful_match = true
        end
      end
    end
    self.save
    return successful_match
  end

end
