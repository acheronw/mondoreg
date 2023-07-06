class BoothsController < ApplicationController

  def new
    @booth = Booth.new
  end

  def create
    booths_to_save = []
    failed_booths = []
    params[:booth_nos].each do | booth_no |
      # if Convention.active.last.booths.find_by(booth_number == booth_no)
      #   flash[:warning] = "Ez a booth már foglalt"
      # end
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
    redirect_back(fallback_location: root_path)
  end


  # def index
  #   @booths = Booth.active.joins(:user).order(booth_number: :asc)
  # end

  def comp_params
    params.require(:booth).permit(:booth_name,
                                  :booth_no
    )
  end

end