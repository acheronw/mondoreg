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

  index do
    selectable_column
    column t('ticketing.order_id'), :id
    column t('ticketing.name_of_buyer'), :user
    column t('ticketing.quantity'), :quantity
    column t('ticketing.total_price'), :sortable => :price do | ticket_order |
      div :class => "column-right" do
        ticket_order.quantity * ticket_order.ticket.price.to_i
      end

    end
    column t('ticketing.status'), :status
    actions
  end

  csv do
    column :id
    column :user
    column :quantity
    column :status
  end


end
