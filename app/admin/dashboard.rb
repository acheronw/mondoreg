ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end


    columns do
      column do
        panel t('admin_dashboard.recent_orders') do
          table_for TicketOrder.pending.active.order(updated_at: :desc).limit(10) do | ticket_order |
            column :id
            column t('ticketing.name_of_buyer'), :user
            column :quantity
            column t('ticketing.total_price') do | ticket_order |
              div :class => "column-right" do
                ticket_order.quantity * ticket_order.ticket.price.to_i
              end
            end
          end
          strong { link_to "All ticket orders", admin_ticket_orders_path('' ) }
        end

      end
      column do
        panel t('admin_dashboard.current_con') do
          if Convention.active.any?
            strong { Convention.active.first.name }
            div do
              no_sold = TicketOrder.active.where(status: 'accepted').sum(:quantity)
              t('admin_dashboard.no_of_confirmed', number: no_sold)
            end
            div do
              no_pending = TicketOrder.requires_attention.sum(:quantity)
              t('admin_dashboard.no_of_pending', number: no_pending)
            end
          else
            # no active convention
          end


        end
      end
    end




    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
