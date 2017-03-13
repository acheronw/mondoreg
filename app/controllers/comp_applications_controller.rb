class CompApplicationsController < ApplicationController


  def show
    @comp_application = CompApplication.find(params[:id])
    if current_user != @comp_application.user
      flash[:danger] = "Access denied! Exterminate user! Exterminate!"
      redirect_to root_path
    end
  end

  def new
    @comp_application = CompApplication.new
    @comp_application.competition_id = params[:competition_id]
  end

  def create
    ap "========================"
    ap params
    ap "<<<<"
    ap comp_params
    ap "<<<<"
    @comp_application = CompApplication.new(comp_params)
    @comp_application.user = current_user
    @comp_application.status = "pending"

    ap @comp_application
    ap "========================"
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

  def edit
    @comp_application = CompApplication.find(params[:id])
  end

  def update
    @comp_application = CompApplication.find(params[:id])
    if not @comp_application.competition.on_sale?
      # The user tried to apply to an invalid competition
      flash[:danger] = t('competition.user_side.competition_error')
      redirect_to root_path
    elsif @comp_application.status != 'resubmit'
      # Only applications in the resubmit state can be edited.
      flash[:danger] = t('competition.user_side.competition_error')
      redirect_to root_path
    else
      @comp_application.status = 'pending'
      if @comp_application.update_attributes(comp_params)
        flash[:success] = t('competition.user_side.application_sent')
        redirect_to root_path
      else
        render 'edit'
      end
    end
  end


  private

  def comp_params
    params.require(:comp_application).permit(:character_name,
                                             :character_source,
                                             :perf_requests,
                                             :competition_id,
                                             :primary_image,
                                             :stage_music,
                                             :extra_image1,
                                             :extra_image2,
                                             :veteran,
                                             :group_members => []
    )
  end

end
