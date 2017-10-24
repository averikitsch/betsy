class ReviewsController < ApplicationController
  def index
  end

  def show
  end

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
        # redirect_to new_product_review_path( params[:product_id]), status: :bad_request # make instance variable
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def review_params
    params.permit(:rating, :body, :nickname, :location, :product_id)
  end
end
