class ReviewsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @product = Product.find_by(id: params[:product_id])
    render_404 unless @product
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    if @review.save
      flash[:success] = :success
      flash[:result_text] = "Successfully added your review"
      redirect_to product_path(@review.product_id)
    else
      flash[:status] = :failure
      flash[:result_text] = "Sorry! We lost your review...oops!"
      flash[:messages] = @review.errors.messages
      redirect_to new_product_review_path( params[:product_id]), status: :bad_request
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
