class CompetitionsController < ApplicationController


  def show
    @competition = Competition.find(params[:id])
    unless ((current_user.has_role? :manager, @competition) || (current_user.has_role? :assistant, @competition))
      flash[:danger] = "Access denied! Exterminate user! Exterminate!"
      redirect_to root_path
    end
  end

  def export_csv
    @competition = Competition.find(params[:id])
    @comp_applications = @competition.comp_applications.where(status: 'accepted').order(:appearance_no).joins(:user).all
    response.headers['Content-Disposition'] = 'attachment; filename=mondocon_tickets.csv'
    render text: @comp_applications.to_csv
  end

end