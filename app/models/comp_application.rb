class CompApplication < ApplicationRecord
  belongs_to :competition, inverse_of: :comp_applications
  belongs_to :user, inverse_of: :comp_applications

  validates :nickname, presence: true
  validates :competition_id, presence: true
  validates :user_id, presence: true
  validates :character_name, presence: true
  validates :character_source, presence: true
  validates :status, presence:true
  validates :status, :inclusion => { :in => ['pending', 'accepted', 'resubmit', 'deleted'],
                                     message: "%value is not a valid ticket status" }

  scope :active, -> { joins(:competition).merge(Competition.active) }

  # This associates the attribute primary_image with a file attachment (Paperclip)
  has_attached_file :primary_image, styles: {
      medium: '400x400>'
  }
  validates_attachment_content_type :primary_image, :content_type => /\Aimage\/.*\Z/, message: 'This is not a proper image'
  validates :primary_image, presence: true

  has_attached_file :stage_music
  validates_attachment_content_type :stage_music, :content_type => ['video/avi', 'video/mp4', 'video/x-ms-wmv', 'audio/mpeg'], message: 'This is not an audio or video file'
  validates :stage_music, presence: true

  has_attached_file :extra_image1, styles: {
      medium: '400x400>'
  }
  validates_attachment_content_type :extra_image1, :content_type => /\Aimage\/.*\Z/, message: 'This is not a proper image'

  has_attached_file :extra_image2, styles: {
      medium: '400x400>'
  }
  validates_attachment_content_type :extra_image2, :content_type => /\Aimage\/.*\Z/, message: 'This is not a proper image'

  validates :group_members, presence: true, if: Proc.new{ |a| a.competition.group_members?  }
  validates :group_name, presence: true, if: Proc.new{ |a| a.competition.group_members?  }

  def confirm
    self.status = "accepted"
    self.appearance_no ||= next_free_number
    if self.save
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

end
