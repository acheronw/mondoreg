class Competition < ApplicationRecord
  belongs_to :convention, inverse_of: :competitions
  has_many :comp_applications, inverse_of: :competition

  validates :name, presence: true
  validates :convention_id, presence: true
  validates :subtype, presence: true
  validates :subtype, :inclusion => { :in => ['craft', 'craft_group', 'perf', 'perf_group', 'eurocosplay', 'rajz', 'rajz_cg'],
                                     message: "%value is not a valid competition type" }
  validates :admin_email, presence: true


  scope :active, -> { joins(:convention).merge(Convention.active) }
  scope :on_sale, -> { where("applications_start <= ?", Date.today).where("applications_end >= ?", Date.today) }

  def on_sale?
    self.applications_start < Date.today && self.applications_end > Date.today
  end

  def full?
    if self.max_applications
      self.comp_applications.length >= self.max_applications
    else
      # A competition with no limit of applications can never be full
      false
    end
  end

  # The following methods are used to check which optional fields are relevant.
  def cosplay_fields?
    ['craft', 'craft_group', 'perf', 'perf_group', 'eurocosplay'].include? self.subtype
  end


  def group_members?
    ['craft_group', 'perf_group'].include? self.subtype
  end

  def perf_requests?
    ['craft', 'craft_group', 'perf', 'perf_group', 'eurocosplay'].include? self.subtype
  end

  def ask_veteran?
    false
    # ['craft', 'craft_group', 'perf', 'perf_group'].include? self.subtype
  end

  def consent_required?
    ['eurocosplay'].include? self.subtype
  end

  def require_music_upload?
    ['craft', 'craft_group', 'perf', 'perf_group', 'eurocosplay'].include? self.subtype
  end

  def extra_images?
    ['craft', 'craft_group', 'eurocosplay', 'rajz_cg'].include? self.subtype
  end

end
