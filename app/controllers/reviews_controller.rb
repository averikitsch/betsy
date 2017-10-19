class ReviewsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def review_params
    params.require(:work).permit(:rating, :body, :nickname, :location)
  end
end
