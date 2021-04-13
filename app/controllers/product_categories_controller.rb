class ProductCategoriesController < ApplicationController

  def show
    @product_category = ProductCategory.find(params[:id])
    @products = @product_category.products.order(name: :desc).page(params[:products_page]).per(10)
  end

end