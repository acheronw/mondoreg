class CompApplicationsController < ApplicationController

  def new
    @comp_application = CompApplication.new
    @comp_application.competition_id = params[:competition_id]
  end

  def create
    puts "================================="
    @comp_application = CompApplication.new(comp_params)
    @comp_application.user = current_user
    @comp_application.status = "pending"
    ap @comp_application
    # Validate that the competition is the correct one, open and not full.
    if @comp_application.competition.full?
      # Competition is invalid. Maybe someone sent in another application and now the competition is full.
      flash[:danger] = t('competition.user_side.competition_already_full')
      redirect_to root_path
    elsif not @comp_application.competition.on_sale?
      # The user tried to apply to an invalid competition
      flash[:danger] = t('competition.user_side.competition_error')
      redirect_to root_path
    else
      if @comp_application.save
        flash[:success] = t('competition.user_side.application_sent')
        redirect_to root_path
      else
        render 'new'
      end
    end




  end



  private

  def comp_params
    params.require(:comp_application).permit(:character_name, :character_source, :group_members, :perf_requests, :competition_id)
  end

end
