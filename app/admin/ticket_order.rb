ActiveAdmin.register TicketOrder do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  permit_params :user_id, :ticket_id, :quantity, :status

  # Ez teszi lehetővé, hogy az indexben a user sort a user táblából joinolt name mezővel tudjuk sort-olni:
  controller do
    def scoped_collection
      end_of_association_chain.includes(:user)
    end
  end

  member_action :confirm_ticket, method: :patch do
    resource.confirm
    flash[:notice] = t('ticketing.ticket_confirmed', id: resource.id)
    redirect_to :back
  end

  member_action :unconfirm_ticket, method: :patch do
    resource.unconfirm
    flash[:notice] = t('ticketing.ticket_unconfirmed', id: resource.id)
    redirect_to :back
  end

  scope I18n.t('ticketing.pending_current'), :requires_attention
  scope I18n.t('ticketing.all_current'), :active
  scope I18n.t('ticketing.scope_all'), :all


  index do
    selectable_column
    column t('ticketing.order_id'), :id
    # column t('ticketing.name_of_buyer'), :user
    # column t('ticketing.name_of_buyer'), :user
    column t('ticketing.name_of_buyer'), :user, :sortable => 'users.name'
    column t('ticketing.quantity'), :quantity
    # column t('ticketing.total_price'), :sortable => :price do | ticket_order |
    #   div :class => "column-right" do
    #     ticket_order.quantity * ticket_order.ticket.price.to_i
    #   end
    # end
    column t('ticketing.status'), :status
    column "Confirmation" do | ticket_order |
      if ticket_order.status == "pending"
        link_to(t('ticketing.confirm_button'), url_for(:action => :confirm_ticket, :id => ticket_order.id), :method => :patch)
      elsif ticket_order.status == "accepted"
        link_to(t('ticketing.unconfirm_button'), url_for(:action => :unconfirm_ticket, :id => ticket_order.id), :method => :patch)
      end

    end
    actions
  end




  csv do
    column t('ticketing.order_id') do | ticket_order |
      "MC" + ticket_order.id.to_s
    end
    column :user do | ticket_order |
      ticket_order.user.name
    end
    column :quantity
    column t('ticketing.total_price') do | ticket_order |
        ticket_order.quantity * ticket_order.ticket.price.to_i
    end
    column :status
  end


end
