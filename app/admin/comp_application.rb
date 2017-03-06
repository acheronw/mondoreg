ActiveAdmin.register CompApplication do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

  permit_params :competition_id, :user_id, :character_name, :character_source, :status, :perf_requests, :admin_msg, group_members: []

  # Ez teszi lehetővé, hogy az indexben a user sort a user táblából joinolt name mezővel tudjuk sort-olni:
  controller do
    def scoped_collection
      end_of_association_chain.includes(:user)
      end_of_association_chain.includes(:competition)
    end
  end

  member_action :accept_application, method: :patch do
    resource.confirm
    flash[:notice] = t('competition.admin.application_accepted', id: resource.id)
    redirect_to :back
  end

  member_action :reject_application, method: :patch do
    resource.reject
    flash[:notice] = t('competition.admin.application_accepted', id: resource.id)
    redirect_to :back
  end



  index do
    selectable_column
    column t('competition.name_of_competitor'), :user, :sortable => 'users.name'
    column t('competition.name_of_character'), :character_name
    column t('competition.source_of_character'), :character_source
    # column t('competition.perf_requests'), :perf_requests
    # column t('competition.group_members'), :group_members
    column t('competition.competition_name'), :competition, :sortable => 'competition.name'
    column t('competition.convention') do | comp_app |
      comp_app.competition.convention.name
    end
    column t('competition.status'), :status
    column "Confirmation" do | comp_app |
      if comp_app.status == "pending"
        link_to(t('competition.admin.confirm_button'), url_for(:action => :accept_application, :id => comp_app.id), :method => :patch)
      elsif comp_app.status == "accepted"
        link_to(t('competition.admin.unconfirm_button'),
                url_for(:action => :reject_application, :id => comp_app.id),
                data: { confirm: (t('competition.admin.confirm_question_on_reject'))},
                :method => :patch
        )
      end
    end
    actions
  end

end
