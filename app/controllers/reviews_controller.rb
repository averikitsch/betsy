class ReviewsController < ApplicationController

  def new
    @product = Product.find_by(id: params[:product_id])
    if find_user && @user.id == @product.user.id
      flash[:status] = :failure
      flash[:result_text] = "Oops..You can't review your own product!"
      redirect_to product_path(@product.id)
    else
      render_404 unless @product
      @review = Review.new
    end
  end

  def create
    @product = Product.find_by(id: params[:product_id])
    if find_user && @user.id == @product.user.id
      flash[:status] = :failure
      flash[:result_text] = "Oops..You can't review your own product!"
      redirect_to product_path(@product.id)
    else
      @review = Review.new(review_params)
      if @review.save
        flash[:success] = :success
        flash[:result_text] = "Successfully added your scares"
        redirect_to product_path(@review.product_id)
      else
        flash[:status] = :failure
        flash[:result_text] = "Boo! Your review ran away!"
        flash[:messages] = @review.errors.messages
        @product = Product.find_by(id: params[:product_id])
        render :new, status: :bad_request
      end
    end
  end


  private
  def review_params
    params.permit(:rating, :body, :nickname, :location, :product_id)
  end
end
