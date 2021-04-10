ActiveAdmin.register Product do

  menu if: proc{ current_admin_user.is_super?}


  permit_params :name, :status, :product_category_id, :author, :isbn, :price, :description, :product_image


  form do |f|
    f.inputs do
      f.input :name
      f.input :product_category
      f.input :status
      f.input :author
      f.input :isbn
      f.input :price
      f.input :description
      f.input :product_image, as: :file
    end
    f.actions
  end


  index do
    selectable_column
    column :name
    column :product_category, :sortable => 'product_category.name'
    column :status
    column :isbn
    column :price
    column :created_at
    column :updated_at
    actions
  end


  show do
    attributes_table do
      row :name
      row :product_category do | product |
        product.product_category.name
      end
      row :status
      row :author
      row :isbn
      row :price
      row :description
      if product.product_image.present?
        row :product_image do | product |
          image_tag (product.product_image.variant(resize: "400x400"))
        end
        row :product_image_fullsize do | product |
          link_to product.product_image.filename, product.product_image.url
        end
      end

    end
  end

end