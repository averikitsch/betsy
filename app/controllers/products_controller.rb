class ProductsController < ApplicationController
  before_action :find_product , only: [:show]
  def root
    @top_products =  Product.select("products.id, avg(reviews.rating) as average_rating").joins("LEFT JOIN reviews ON products.id = reviews.product_id").group("products.id").order("average_rating DESC NULLS LAST").limit(6)
    #Product.joins("LEFT JOIN order_products ON products.id = order_products.product_id").group(:id).order("count(order_products.id)  DESC").limit(10)
    @recent_products =  Product.order(created_at: :desc).limit(6)
  end

  def index
    @products = Product.order(:id)
  end

  def show
    @order_product = OrderProduct.new
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def find_product
    @product = Product.find_by(id: params[:id])
    render_404 unless @product
  end
end
