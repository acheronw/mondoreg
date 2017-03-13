class CompApplication < ApplicationRecord
  belongs_to :competition, inverse_of: :comp_applications
  belongs_to :user, inverse_of: :comp_applications

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

  def confirm
    self.status = "accepted"
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

end
