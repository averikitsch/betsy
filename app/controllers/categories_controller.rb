class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def new
    if @user.nil?
      flash[:status] = :failure
      flash[:result_text] = "Dearest Paranormal Ally. You are sneaky. You must be logged in to add a new category."
      redirect_to root_path, status: :bad_request
    else
      @category = Category.new
    end
  end

  def create
    if @user.nil?
      flash[:status] = :failure
      flash[:result_text] = "Dearest Paranormal Ally. You are sneaky. You must be logged in to add a new category."
      redirect_to root_path
    else
      @category = Category.new category_params
      if @category.save
        redirect_to categories_path
      else
        render :new
      end
    end
  end

  private

  def category_params
    return params.require(:category).permit(:name)
  end
end
