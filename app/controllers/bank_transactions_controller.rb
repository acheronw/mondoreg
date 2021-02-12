class BankTransactionsController < ApplicationController
  before_action :bursar_user

  def destroy
    BankTransaction.find(params[:id]).destroy
    flash[:notice] = "TRANZAKCIÓ TÖRÖLVE"
    redirect_back(fallback_location: root_path)
  end

  def set_done
    @bank_transaction = BankTransaction.find(params[:id])
    @bank_transaction.update(status: 'done')
    flash[:notice] = "TRANZAKCIÓ RENDEZVE"
    redirect_back(fallback_location: root_path)
  end

  def set_problematic
    @bank_transaction = BankTransaction.find(params[:id])
    @bank_transaction.update(status: 'problematic')
    redirect_back(fallback_location: root_path)
  end


  def import
    message = BankTransaction.import(params[:file])
    flash[:notice] = message
    redirect_back(fallback_location: root_path)
  end

  private
    def bursar_user
      redirect_to root_url unless user_signed_in? && current_user.has_role?(:bursar)
    end

end