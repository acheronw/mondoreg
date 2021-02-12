class BankTransactionsController < ApplicationController
  before_action :bursar_user

  def destroy
    BankTransaction.find(params[:id]).destroy
    redirect_back
      # , notice: "TRANZAKCIÓ TÖRÖLVE"
  end

  def set_done
    @bank_transaction = BankTransaction.find(params[:id])
    @bank_transaction.update(status: 'done')
    redirect_back
      # , notice: "TRANZAKCIÓ RENDEZVE"
  end

  def set_problematic
    @bank_transaction = BankTransaction.find(params[:id])
    @bank_transaction.update(status: 'problematic')
    redirect_back
  end


  def import
    message = BankTransaction.import(params[:file])
    redirect_back
      #, notice: message
  end

  private
    def bursar_user
      redirect_to root_url unless user_signed_in? && current_user.has_role?(:bursar)
    end

end