class BoothsController < ApplicationController

  def new
    @booth = Booth.new
  end

  def create
    successful_saves = []
    failed_saves = []
    params[:booth_nos].each do | booth_no |
      # if Convention.active.last.booths.find_by(booth_number == booth_no)
      #   flash[:warning] = "Ez a booth már foglalt"
      # end
      @booth = Booth.new(booth_number: booth_no)
      @booth.booth_name = params[:booth][:booth_name]
      @booth.convention = Convention.active.last
      @booth.user = current_user
      @booth.status = 'submitted'
      if @booth.save
        successful_saves << booth_no
      else
        failed_saves << booth_no
      end
    end
    if successful_saves.any?
      if failed_saves.any?
        flash[:danger]  = t('booth.booked_mixed_results', good_nos: successful_saves, bad_nos: failed_saves)
      else
        flash[:success] = t('booth.booked_successfully', good_nos: successful_saves)
      end
    else
      if failed_saves.any?
        flash[:danger]  = t('booth.booked_failure', bad_nos: failed_saves)
        flash[:danger] = @booth.errors.full_messages
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