class BankTransaction < ApplicationRecord
  validates :csv_line, uniqueness: true

  scope :requires_human, -> {where(status: ['pending', 'problematic'])}

  def self.import(file)
    successful_counter = 0
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
        bt.comment_of_transaction = row["Közlemény"]
        bt.sender_of_transaction= row["Partner neve"]
        # We set everything to pending at this point. We do proper processing after a successful save.
        bt.status = "pending"
        if bt.save
          successful_counter += 1
        else
          duplicates << bt.csv_line
          duplicate_counter += 1
        end
      end
    end

    message = "SIKERESEN beimportáltunk #{successful_counter} befizetést."
    if duplicate_counter > 0
      message += "|\tDUPLIKÁTUMOK, amiket nem importáltunk be: #{duplicate_counter}"
      message += "|\tLegelső duplikátum: #{duplicates.first}\t|\tLegutolsó duplikátum: #{duplicates.last}"
    end

    return message
  end

end
