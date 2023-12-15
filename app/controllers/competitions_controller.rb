class CompetitionsController < ApplicationController


  def show
    @competition = Competition.find(params[:id])
    unless @competition.can_user_manage?current_user
      flash[:danger] = "Access denied! Exterminate user! Exterminate!"
      redirect_to root_path
    end
  end

  def export_csv
    @competition = Competition.find(params[:id])
    @comp_applications = @competition.comp_applications.where(status: 'accepted').order(:appearance_no).joins(:user).all
    # response.headers['Content-Disposition'] = "attachment; filename=competition_#{@competition.id}_list.csv"

    send_data @comp_applications.to_csv, :filename => 'competitors.csv'
    # render text: @comp_applications.to_csv
  end

end