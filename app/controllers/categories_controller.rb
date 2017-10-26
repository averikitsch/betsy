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
        flash[:status] = :success
        flash[:result_text] = "Successfully created category: #{@category.name}!"
        redirect_to user_path(session[:user_id])
      else
        flash[:status] = :failure
        flash[:result_text] = "Boo!"
        flash[:messages] = @category.errors.messages
        render :new, status: :bad_request
      end
    end
  end

  private

  def category_params
    return params.require(:category).permit(:name)
  end
end
