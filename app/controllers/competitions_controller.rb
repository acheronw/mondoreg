class CompetitionsController < ApplicationController


  def show
    @competition = Competition.find(params[:id])
    ap params[:id]
    ap @competition.id
    unless ((current_user.has_role? :manager, @competition) || (current_user.has_role? :assistant, @competition))
      flash[:danger] = "Access denied! Exterminate user! Exterminate!"
      redirect_to root_path
    end
  end

end