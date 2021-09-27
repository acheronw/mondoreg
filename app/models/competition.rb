class Competition < ApplicationRecord
  belongs_to :convention, inverse_of: :competitions
  has_many :comp_applications, inverse_of: :competition

  validates :name, presence: true
  validates :convention_id, presence: true
  validates :subtype, presence: true
  validates :subtype, :inclusion => { :in => ['craft', 'craft_group', 'perf', 'perf_group', 'eurocosplay', 'blizzard_cp', 'rajz', 'rajz_cg', 'karaoke'],
                                     message: "%value is not a valid competition type" }
  validates :admin_email, presence: true

  # Limited choice of musics for the Blizzard cosplay competition
  #
  # The proper way would be: add a new array of strings column to the competition model.
  # Set the values of that field for that specific competition.
  # But it means an extra migrate and a column which might never be used again...
  # Also populating the list requires either to code a specific UI for that (at least in activeadmin)
  # Or to add that in the console.
  # So the current solution might be monkey patching, but it was much simpler.
  MUSIC_OPTIONS = ["DIABLO I / II - Tristram Village",
                   "DIABLO II - Leoric",
                   "DIABLO II - Lord of Destruction Main Theme",
                   "DIABLO III: REAPER OF SOULS - Crusader",
                   "DIABLO III: REAPER OF SOULS - The Wrath of Angels",
                   "HEARTHSTONE: HEROES OF WARCRAFT - One Last Chance",
                   "HEARTHSTONE: HEROES OF WARCRAFT - The Arena Awaits",
                   "HEROES OF THE STORM – The Battle Begins",
                   "HEROES OF THE STORM / LOST VIKINGS 2 - Smugglers Cove",
                   "OVERWATCH - Prepare to Attack",
                   "OVERWATCH - Rally the Heroes",
                   "STARCRAFT - Opening Theme",
                   "STARCRAFT - Terran One",
                   "STARCRAFT II: WINGS OF LIBERTY - Card to Play",
                   "STARCRAFT II: LEGACY OF THE VOID - Khala's End",
                   "STARCRAFT II: LEGACY OF THE VOID - The Stars Our Home",
                   "WARCRAFT II - Opening Theme",
                   "WARCRAFT III - Arthas's Betrayal",
                   "WARCRAFT III - Blackrock and Roll",
                   "WORLD OF WARCRAFT - A Call to Arms",
                   "WORLD OF WARCRAFT - Legends of Azeroth",
                   "WORLD OF WARCRAFT -  Nightsong",
                   "WORLD OF WARCRAFT - Zul'Gurub Voodoo",
                   "WORLD OF WARCRAFT: WRATH OF THE LICH KING - Invincible",
                   "WORLD OF WARCRAFT: BATTLE FOR AZEROTH - Freehold",
                   "WORLD OF WARCRAFT: LEGION - Anduin, part 2",
                   'WORLD OF WARCRAFT: LEGION - Highmountain',
                   "WORLD OF WARCRAFT: LEGION - Azeroth's Last Hope",
                   "Sharm - Teldrassil Burns",

  ]

  scope :active, -> { joins(:convention).merge(Convention.active) }
  scope :on_sale, -> { where("applications_start <= ?", Date.today).where("applications_end >= ?", Date.today) }

  # This is for Rolify:
  resourcify

  def on_sale?
    self.applications_start <= Date.today && self.applications_end >= Date.today
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
  def is_cosplay?
    ['craft', 'craft_group', 'perf', 'perf_group', 'eurocosplay', 'blizzard_cp'].include? self.subtype
  end

  def is_karaoke?
    ['karaoke'].include? self.subtype
  end

  def is_drawing?
	  ['rajz', 'rajz_cg'].include? self.subtype
  end

  def has_image?
    not self.is_karaoke?
  end

  def group_members?
    ['craft_group', 'perf_group'].include? self.subtype
  end

  def perf_requests?
    ['craft', 'craft_group', 'perf', 'perf_group', 'eurocosplay', 'blizzard_cp'].include? self.subtype
  end

  def ask_veteran?
    ['craft', 'craft_group'].include? self.subtype
  end

  def ask_age?
    ['rajz', 'rajz_cg'].include? self.subtype
  end

  def consent_required?
    ['eurocosplay'].include? self.subtype
  end

  def require_music_upload?
    ['craft', 'craft_group', 'perf', 'perf_group', 'eurocosplay'].include? self.subtype
  end

  def select_music_from_list?
    ['blizzard_cp'].include? self.subtype
  end
  
  def extra_images?
    ['craft', 'craft_group', 'eurocosplay','blizzard_cp', 'rajz_cg'].include? self.subtype
  end
  
  def can_user_manage?(user)
	  (user.has_role? :manager, self) ||
	  ((self.is_cosplay?) && (user.has_role? :cosplay_admin)) ||
	  ((self.is_karaoke?) && (user.has_role? :karaoke_admin)) ||
	  ((self.is_drawing?) && (user.has_role? :drawing_admin))
  end
  
end
