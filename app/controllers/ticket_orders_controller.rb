class TicketOrdersController < ApplicationController
  before_action :bursar_user, only: [:index, :confirm_ticket, :unconfirm_ticket, :refund_ticket, :export_csv]
  before_action :ticketeer_user, only: [:deliver_ticket, :lookup_ticket]

  # This makes the helpers available in the view:
  helper_method :sort_column, :sort_direction


  def create
    @ticket_order = current_user.ticket_orders.build(ticket_order_params)
    @ticket_order.status = "pending"
    tickets_on_sale = Ticket.on_sale.pluck(:id)
    if tickets_on_sale.include? @ticket_order.ticket_id
      if @ticket_order.ticket.full?
        flash[:danger] = "That ticket type is fully booked!"
        redirect_to root_path
      elsif @ticket_order.save
        redirect_to payment_checkout_path("MC" + @ticket_order.id.to_s)
        # flash[:success] = t('ticketing.user_side.order_placed_message')
        # ApplicationMailer.ticket_ordered_email(@ticket_order).deliver_now
        # redirect_to root_path
      else
        flash[:danger] = @ticket_order.errors.full_messages
        redirect_to root_path
      end
    else
      # The user tried to hack the params and by a ticket that's not on sale.
      # I was unable to put this filter into the strong params permit method.
      flash[:danger] = "That ticket type is not on sale!"
      redirect_to root_path
    end
  end

  def index
    # Version using will_paginate gem for pagination:
    # @ticket_orders = TicketOrder.active.joins(:user).order(sort_column + " " + sort_direction)
    #                     .paginate(page: params[:ticket_orders_page], per_page: 100).all
    # Version using kaminari gem for pagionation:
    @ticket_orders = TicketOrder.active.joins(:user).order(sort_column + " " + sort_direction)
    @ticket_orders = @ticket_orders.page(params[:ticket_orders_page]).per(100)
    # If using csv format but don't want pagination, replace previous line with this:
    # @ticket_orders = @ticket_orders.page(params[:ticket_orders_page]).per(100) unless request.format == 'csv

    respond_to do | format |
      format.html
      # format.csv { send_data text: @ticket_orders.to_csv }
    end
  end

  def lookup_ticket
    @ticket_order = TicketOrder.find_by(id: params[:ticket_id])
    if @ticket_order
      redirect_to ticket_order_path(@ticket_order.id)
    else
      flash[:warning] = t('ticketing.id_not_found', id: params[:ticket_id])
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    @ticket_order = TicketOrder.find(params[:id])
    if current_user != @ticket_order.user &&
        !current_user.has_role?(:ticketeer)
      flash[:danger] = "Access denied! Exterminate user! Exterminate!"
      redirect_to root_path
    end
  end


  def export_csv
    @ticket_orders = TicketOrder.active.joins(:user).all
    send_data @ticket_orders.to_csv, :filename => 'mondocon-tickets.csv'
  end

  def deliver_ticket
    @ticket_order = TicketOrder.find(params[:id])
    if @ticket_order.status == 'accepted'
      @ticket_order.change_to_delivered(current_user.id)
      flash[:notice] = t('ticketing.ticket_delivered', id: @ticket_order.id)
      redirect_back(fallback_location: root_path)
    else
      flash[:warning] = t('ticketing.ticket_not_delivered', id: @ticket_order.id)
      redirect_back(fallback_location: root_path)
    end
  end

  # I think this method is never called:
  def confirm_ticket
    @ticket_order = TicketOrder.find(params[:id])
    @ticket_order.confirm(params[:payment_type])
    flash[:notice] = t('ticketing.ticket_confirmed', id: @ticket_order.id)
    redirect_back(fallback_location: root_path)
  end

  def unconfirm_ticket
    @ticket_order = TicketOrder.find(params[:id])
    @ticket_order.unconfirm
    flash[:notice] = t('ticketing.ticket_unconfirmed', id: @ticket_order.id)
    redirect_back(fallback_location: root_path)
  end

  def refund_ticket
    @ticket_order = TicketOrder.find(params[:id])
    @ticket_order.refund
    flash[:notice] = t('ticketing.ticket_refunded', id: @ticket_order.id)
    redirect_back(fallback_location: root_path)
  end

  def reminder_email
    @ticket_order = TicketOrder.find(params[:id])
    if admin_user_signed_in? || current_user.has_role?(:bursar) || current_user == @ticket_order.user
      if @ticket_order.status == 'pending'
        ApplicationMailer.ticket_ordered_email(@ticket_order).deliver_now
      elsif @ticket_order.status == 'accepted'
        ApplicationMailer.ticket_confirmed_email(@ticket_order).deliver_now
      end
      flash[:success] = t('ticketing.user_side.resent_instructions_message')
    end
    redirect_back(fallback_location: root_path)
  end

  private
    def ticket_order_params
      params.require(:ticket_order).permit(:quantity, :ticket_id, :payment_type)
    end

    def bursar_user
      redirect_to root_url unless user_signed_in? && current_user.has_role?(:bursar)
    end

    def ticketeer_user
      redirect_to root_url unless user_signed_in? && current_user.has_role?(:ticketeer)
    end

    def sort_column
      # Sanitizing the input because it goes into SQL,
      # also handle situations where the sort_column is not set yet.
      if ['id', 'name', 'quantity', 'total_price', 'status'].include?(params[:sort])
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
