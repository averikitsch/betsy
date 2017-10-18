class ProductsController < ApplicationController
  before_action :find_product , only: [:show]
  def root
    #I want to find prodcuts that were bought the most
    #TODO: add quantity * count to top prodcuts
    @top_products = Product.joins("LEFT JOIN order_products ON products.id = order_products.product_id").group(:id).order("count(order_products.id)  DESC").limit(10)
    @recent_products =  Product.order(created_at: :desc).limit(10)
  end

  def index
  end

  def show

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
