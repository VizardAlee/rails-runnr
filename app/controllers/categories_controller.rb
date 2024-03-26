class CategoriesController < ApplicationController
  def show
    logger.debug("Frontend category show action accessed") 

    @category = Category.find(params[:id])
    @products = @category.products
  end
end