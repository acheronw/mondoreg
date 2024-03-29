ActiveAdmin.register CompApplication do
  menu if: proc{ current_admin_user.access_competitions?}
  
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

  permit_params :competition_id, :user_id, :character_name, :character_source, :status, :perf_requests, :admin_msg,
                :appearance_no, :group_name, :nickname, :group_name, :group_members, :veteran, :inner_memo, :age,
                :age_in_years, :combo_comp, :schedule_picked


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
    redirect_back(fallback_location: root_path)
  end

  member_action :reject_application, method: :patch do
    resource.reject
    flash[:notice] = t('competition.admin.application_rejected', id: resource.id)
    redirect_back(fallback_location: root_path)
  end


  filter :competition, collection: proc { Competition.active.all.map { | c | [c.name, c.id]  } }
  filter :status, as: :select, collection: ['pending', 'accepted', 'resubmit']

  index download_links: [:csv] do
    selectable_column
    column t('competition.name_of_competitor'), :user, :sortable => 'users.name'
    column t('competition.nickname'), :nickname
    column t('competition.name_of_character'), :character_name
    column t('competition.source_of_character'), :character_source
    # column t('competition.perf_requests'), :perf_requests
    # column t('competition.group_members'), :group_members
    column t('competition.competition_name'), :competition, :sortable => 'competition.name'
    column t('competition.convention') do | comp_app |
      comp_app.competition.convention.name
    end
    column t('competition.admin.appearance_no'), :appearance_no
    column :admin_msg
    column t('competition.status'), :status do | comp_app |
      case comp_app.status
        when 'pending'
          status_tag (t('competition.state_pending')), class: 'warning'
        when 'accepted'
          status_tag (t('competition.state_accepted')), class: 'ok'
        when 'resubmit'
          status_tag (t('competition.state_resubmit'))
      end
    end
    column t('competition.admin.confirm_button') do | comp_app |
      if comp_app.status == "pending"
        link_to(t('competition.admin.confirm_button'), url_for(:action => :accept_application, :id => comp_app.id), :method => :patch)
      end
    end
    column t('competition.admin.unconfirm_button') do | comp_app |
      link_to(t('competition.admin.unconfirm_button'),
              url_for(:action => :reject_application, :id => comp_app.id),
              data: { confirm: (t('competition.admin.confirm_question_on_reject'))},
              :method => :patch
      )
    end
    actions
  end


  show do
    attributes_table do
      row :competition
      row :convention do | comp_a |
        comp_a.competition.convention.name
      end
      row :appearance_no
      row :user
      row :nickname
      row :character_name
      row :character_source
      row :group_name

      if comp_application.primary_image.present?
        row :primary_image do | comp_a |
          image_tag (comp_a.primary_image.variant(resize: "400x400"))
        end
        row :primary_image_fullsize do | comp_a |
          link_to comp_a.primary_image.filename, comp_a.primary_image.url
        end
      end

      if comp_application.extra_image1.present?
        row :extra_image1 do | comp_a |
          image_tag (comp_a.extra_image1.variant(resize: "400x400"))
        end
        row :extra_image1_fullsize do | comp_a |
          link_to comp_a.extra_image1.filename, comp_a.extra_image1.url
        end
      end

      if comp_application.extra_image2.present?
        row :extra_image2 do | comp_a |
          image_tag (comp_a.extra_image2.variant(resize: "400x400"))
        end
        row :extra_image2_fullsize do | comp_a |
          link_to comp_a.extra_image2.filename, comp_a.extra_image2.url
        end
      end

      if comp_application.stage_music.present?
        row :stage_music do | comp_a |
          link_to comp_a.stage_music.filename, comp_a.stage_music.url
        end
      end


      row :group_members

      row :perf_requests

      row :veteran

      row :age

      row :age_in_years

      row :admin_msg

    end
    active_admin_comments
  end

  csv force_quotes: true, col_sep: ";"  do

    column :convention do | comp_a |
      comp_a.competition.convention.name
    end
    column :competition do | comp_a |
      comp_a.competition.name
    end
    column :user do | comp_a |
      comp_a.user.name
    end
    column :appearance_no
    column :character_name
    column :character_source
    column :group_name
    column :group_members

    column :status
    column :veteran

    column :perf_requests

  end

end
