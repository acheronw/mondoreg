class BoothsController < ApplicationController

  def new
    @booth = Booth.new
  end

  def create
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
        flash[:success] = t('booth.booked_successfully')
      else
        flash[:danger] = @booth.errors.full_messages
      end
    end
    redirect_to root_path
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