class CategoriesController < ApplicationController
  def index
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new
    if @category.save
      redirect_to users_path
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def category_params
    return params.require(:category).permit(:name)
  end
end
