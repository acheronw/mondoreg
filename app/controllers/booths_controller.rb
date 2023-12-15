class BoothsController < ApplicationController

  before_action :vendor_user, only: [:create]

  def cancel_current
    count = current_user.booths.active.count
    current_user.booths.active.destroy_all
    flash[:warning] = t('booth.cancelled', count: count)
    redirect_back(fallback_location: root_path)
  end

  def create
    booth_amount = params[:booth_nos].length + current_user.booths.active.count
    if booth_amount > booth_allowance
      flash[:danger]  = t('booth.overbooking', amount: booth_amount, allowance: booth_allowance)
    else
      booths_to_save = []
      failed_booths = []
      params[:booth_nos].each do | booth_no |
        booth = Booth.new(booth_number: booth_no)
        booth.booth_name = params[:booth][:booth_name]
        booth.convention = Convention.active.last
        booth.user = current_user
        booth.status = 'submitted'
        if booth.valid?
          booths_to_save << booth
        else
          failed_booths << booth
        end
      end
      if failed_booths.any?
        flash[:danger]  = t('booth.booked_failure', bad_nos: failed_booths.map(&:booth_number))
        flash[:danger] = failed_booths.first.errors.full_messages
      else
        booths_to_save.each do | booth |
          if booth.save
            flash[:success] = t('booth.booked_successfully', good_nos: booths_to_save.map(&:booth_number))
          else
            flash[:danger]  = t('booth.booked_failure', bad_nos: failed_saves)
            flash[:danger] = booth.errors.full_messages
            break
          end
        end
      end
    end
    redirect_back(fallback_location: root_path)
  end

  def new
    @booth = Booth.new
  end


  # def index
  #   @booths = Booth.active.joins(:user).order(booth_number: :asc)
  # end
  private

    def comp_params
      params.require(:booth).permit(:booth_name,
                                    :booth_no
      )
    end

    def booth_allowance
      if current_user.has_role?(:vendor1)
        return 1
      elsif current_user.has_role?(:vendor2)
        return 2
      elsif current_user.has_role?(:vendor3)
        return 3
      else
        return 0
      end
    end

    def vendor_user
      redirect_to root_url unless user_signed_in? && current_user.is_vendor?
    end



end