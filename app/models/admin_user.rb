class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :timeoutable

  after_create { | admin | admin.send_reset_password_instructions }

  def password_required?
    new_record? ? false : super
  end

  def is_super?
    access_levels == 'super'
  end

  def access_ticketing?
    ['super', 'ticketing', 'both'].include? access_levels
  end

  def access_competitions?
    ['super', 'competitions', 'both'].include? access_levels
  end

end
