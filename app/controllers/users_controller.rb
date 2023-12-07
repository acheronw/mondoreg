class UsersController < ApplicationController
  before_action :bursar_user, only: [:index, :export_subscriber_csv]

  # This makes the helpers available in the view:
  helper_method :sort_column, :sort_direction

  def edit
    @user = User.find(params[:id])
    unless (current_user == @user)
      flash[:danger] = "Access denied! Exterminate user! Exterminate!"
      redirect_to root_path
	end
  end

  def edit_subscription
    @user = current_user    

    unless (current_user == @user)
      flash[:danger] = "Access denied! Exterminate user! Exterminate!"
      redirect_to root_path
	end
    if @user.update(user_params)
      flash[:success] = 'Frissítettük az előfizetői adataidat.'
      # redirect_to root_path
      render 'edit'
    else
      render 'edit'
    end
        
  end

  def index
    if params[:listtype] == "all"
      @users = User.interested_mag.order(sort_column + " " + sort_direction)
    else
      @users = User.active_sub.order(sort_column + " " + sort_direction)
    end
    @users = @users.page(params[:users_page]).per(50)
    
  end

  def export_subscriber_csv
    issue_name = params[:issue]
    ap "The issue we are looking for is #{issue_name}"
    @users = User.joins(:postages).where(postages: { item: issue_name}).distinct
    send_data @users.to_csv, :filename => "mondo_#{issue_name}_subscribers.csv"
  end


  private

    def user_params
      params.require(:user).permit(:subscription_name,
                                   :subscription_email,
                                   :subscription_zip,
                                   :subscription_city,
                                   :subscription_address,
                                   :subscription_uptime,
      )
    end

    def bursar_user
      redirect_to root_url unless user_signed_in? && current_user.has_role?(:bursar)
    end

    def sort_column
      # Sanitizing the input because it goes into SQL,
      # also handle situations where the sort_column is not set yet.
      if ['id', 'name', 'subscription_uptime'].include?(params[:sort])
        params[:sort]
      else
        "id"
      end
    end

    def sort_direction
      # Sanitizing the input because it goes into SQL,
      # also handle situations where the sort_direction is not set yet.
      ['asc', 'desc'].include?(params[:direction]) ? params[:direction] : "desc"
    end

end

