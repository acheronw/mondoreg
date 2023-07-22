class MondoSubscriptionsController < ApplicationController
  before_action :bursar_user, only: [:index, :export_csv]

  def create
    @mondo_subscription = current_user.mondo_subscriptions.build(mondo_subscription_params)
    @mondo_subscription.status = "pending"
    
    if @mondo_subscription.save
      redirect_to payment_checkout_path("MAG" + @mondo_subscription.id.to_s)
    else
      flash[:danger] = @mondo_subscription.errors.full_messages
      redirect_to root_path
      end

  end
  
  private
    def mondo_subscription_params
      params.require(:mondo_subscription).permit(:duration)
    end
    
end