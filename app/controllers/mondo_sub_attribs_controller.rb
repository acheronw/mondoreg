class MondoSubAttribsController < ApplicationController
  before_action :bursar_user

  def create
    ap "Hello create sub attrib!"
    issue_name = mondo_sub_attrib_params[:value]
    ap issue_name
    no_of_subscribers = PostageService.create_issue(issue_name)
    if no_of_subscribers
      flash[:success] = "Sikeresen létrehoztuk az új számot, #{no_of_subscribers} előfizetőnek kell postázni."
      redirect_back fallback_location: root_path
    else
      flash[:error] = "Nem sikerült létrehozni az új számot"
      redirect_back fallback_location: root_path
    end
  end

  private
    def bursar_user
      redirect_to root_url unless user_signed_in? && current_user.has_role?(:bursar)
    end

    def mondo_sub_attrib_params
      params.require(:mondo_sub_attrib).permit(:value)
    end



end
