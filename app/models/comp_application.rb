class CompApplication < ApplicationRecord
  belongs_to :competition, inverse_of: :comp_applications
  belongs_to :user, inverse_of: :comp_applications

  # This is a virtual attribute (does not go into the DB)
  attr_accessor :consent

  validates :competition_id, presence: true
  validates :user_id, presence: true
  validates :character_name, presence: true, if: Proc.new{ |a| a.competition.is_cosplay?  }
  validates :character_source, presence: true, if: Proc.new{ |a| a.competition.is_cosplay?  }

  validates :selected_music, presence: true, if: Proc.new{ |a| a.competition.select_music_from_list? }
  validates :selected_music, inclusion: {in: Competition::MUSIC_OPTIONS }, if: Proc.new{ |a| a.competition.select_music_from_list? }


  validates :status, presence:true
  validates :status, :inclusion => { :in => ['pending', 'accepted', 'resubmit', 'deleted'],
                                     message: "%value is not a valid ticket status" }

  scope :active, -> { joins(:competition).merge(Competition.active) }


  has_one_attached :primary_image
  validates :primary_image, attached: true, if: Proc.new{ |a| a.competition.has_image?  }
  validates :primary_image, content_type: /\Aimage\/.*\Z/

  has_one_attached :stage_music
  validates :stage_music, attached: true, if: Proc.new{ |a| a.competition.require_music_upload?  }
  validates :stage_music, content_type: ['video/avi', 'video/mp4', 'video/x-ms-wmv','video/x-msvideo', 'audio/mpeg']
  validates :stage_music, content_type: ['video/avi', 'video/mp4', 'video/x-ms-wmv','video/x-msvideo', 'audio/mpeg'], if: Proc.new{ |a| a.competition.is_amv? }

  has_one_attached :extra_image1
  has_one_attached :extra_image2
  validates :extra_image1, content_type: /\Aimage\/.*\Z/
  validates :extra_image2, content_type: /\Aimage\/.*\Z/


  validates :group_members, presence: true, if: Proc.new{ |a| a.competition.group_members?  }
  validates :group_name, presence: true, if: Proc.new{ |a| a.competition.group_members?  }

  def confirm
    self.status = "accepted"
    self.appearance_no ||= next_free_number
    if self.save
      # If cosplay confirmations mails are different (at some point they had an attached info sheet picture)
      # if self.competition.is_cosplay?
      #   ApplicationMailer.cosplay_comp_application_confirmed_email(self).deliver_now
      # else
      #   ApplicationMailer.comp_application_confirmed_email(self).deliver_now
      # end
      # If all use the same structure:
      ApplicationMailer.comp_application_confirmed_email(self).deliver_now
    end
  end

  def reject(explanation = nil)
    self.status = "resubmit"
    self.admin_msg = explanation if explanation
    if self.save
      ApplicationMailer.comp_application_rejected_email(self).deliver_now
    end
  end

  def status_localized
    return case status
             when "pending"
               I18n.t('competition.state_pending')
             when "accepted"
               I18n.t('competition.state_accepted')
             when "resubmit"
               I18n.t('competition.state_resubmit')
           end
  end

  def next_free_number
    numbers = CompApplication.where(competition: self.competition).pluck(:appearance_no)
    largest_number = numbers.compact.max || 0
    return largest_number + 1
  end

  def self.to_csv
    attributes = ['number', 'name', 'nickname', 'character', 'fandom']
    CSV.generate(headers: true) do | csv |
      csv << attributes
      all.each do | comp_application |
        csv << [comp_application.appearance_no,
                comp_application.user.name.to_s,
                comp_application.nickname,
                comp_application.character_name,
                comp_application.character_source
        ]
      end
    end
  end

end
