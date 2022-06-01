class CompApplicationsController < ApplicationController


  def show
    @comp_application = CompApplication.find(params[:id])
    unless ((current_user == @comp_application.user) ||
        (@comp_application.competition.can_user_manage? (current_user)))
      flash[:danger] = "Access denied! Exterminate user! Exterminate!"
      redirect_to root_path
	  end
  end

  def new
    @comp_application = CompApplication.new
    @comp_application.competition_id = params[:competition_id]
  end

  def create
    @comp_application = CompApplication.new(comp_params)
    @comp_application.user = current_user
    @comp_application.status = "pending"

    if @comp_application.competition.consent_required? && (@comp_application.consent == "0")
      # Validate that the consent checkbox was ticked in if it was required
      flash[:danger] = t('competition.user_side.consent_must_be_given')
      render 'new'
    elsif @comp_application.competition.full?
      # Validate that the competition is the correct one, open and not full.
      # Maybe someone sent in another application and now the competition is full.
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
      if @comp_application.update(comp_params)
        flash[:success] = t('competition.user_side.application_sent')
        redirect_to root_path
      else
        render 'edit'
      end
    end
  end

  def accept_application
    @comp_application = CompApplication.find(params[:id])
    if @comp_application.competition.can_user_manage? (current_user)
      @comp_application.confirm
      flash[:notice] = t('competition.admin.application_accepted', id: @comp_application.id)
      redirect_back(fallback_location: root_path)
    else
      redirect_to root_path
    end

  end

  def reject_application
    @comp_application = CompApplication.find(params[:id])
    if @comp_application.competition.can_user_manage? (current_user)
      @comp_application.reject()
      flash[:notice] = t('competition.admin.application_rejected', id: @comp_application.id)
      redirect_back(fallback_location: root_path)
    else
      redirect_to root_path
    end

  end

  def update_memo
    @comp_application = CompApplication.find(params[:id])
    if @comp_application.competition.can_user_manage? (current_user)
      @comp_application.inner_memo=params[:comp_application][:inner_memo]
      @comp_application.save
      flash[:notice] = @comp_application.inner_memo
      redirect_back(fallback_location: root_path)
    else
      redirect_to root_path
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
                                               :selected_music,
                                               :extra_image1,
                                               :extra_image2,
                                               :veteran,
                                               :group_name,
                                               :group_members,
                                               :nickname,
                                               :consent,
                                               :age,
                                               :age_in_years,
                                               :karaoke1,
                                               :karaoke2,
      )
    end

end
