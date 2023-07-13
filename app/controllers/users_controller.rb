class UsersController < ApplicationController

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
    print ("===================")
    if @user.update(user_params)
      flash[:success] = 'Frissítettük az előfizetői adataidat.'
      # redirect_to root_path
      render 'edit'
    else
      render 'edit'
    end
        
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

end

