ActiveAdmin.register ProductCategory do
  menu if: proc{ current_admin_user.is_super?}



  form do |f|
    f.inputs do
      f.input :name
      f.input :parent
      f.input :status
      f.input :description
      f.input :product_image, as: :file
    end
    f.actions
  end


  show do
    attributes_table do
      row :name
      row :parent do | product_category |
        product_category.parent.name
      end
      row :status
      row :description
      if product_category.product_image.present?
        row :product_image do | product_category |
          image_tag (product_category.product_image.variant(resize: "400x400"))
        end
        row :product_image_fullsize do | product_category |
          link_to product_category.product_image.filename, product_category.product_image.url
        end
      end

    end
  end

  index do
    column :name
    selectable_column
    column 'Parent' do | product_categories |
      product_categories.parent
    end
    column :status
    column :description
    actions
  end
  permit_params :name, :parent_id, :description, :status, :product_image

end
