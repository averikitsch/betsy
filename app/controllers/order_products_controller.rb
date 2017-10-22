class OrderProductsController < ApplicationController
  before_action :find_op, only: [:edit, :update, :destroy]

  def index
  end

  def show
  end

  def new
  end

  def create
    if session[:order_id].nil?
      @order = Order.create(status: "pending")
      session[:order_id] = @order.id
    else
      @order = Order.find_by(id: session[:order_id])
    end
    @op = @order.order_products.find_by(product_id: params[:id])
    if @op
      @op.quantity += params[:order_product][:quantity].to_i
    else
      @op = OrderProduct.new(op_params)
      @op.product_id = params[:id]
      @op.order_id =  session[:order_id]
    end
    if @op.save
      flash[:status] = :success
      flash[:result_text] = "Successfully summoned to your coffin!"
      redirect_to product_path(params[:id])
    else
      flash[:status] = :failure
      flash[:result_text] = "Oops!"
      flash[:messages] = @op.errors.messages
      redirect_to product_path(params[:id])
    end
  end

  def edit
  end

  def update
    if @order_product.update(op_params)
      flash[:status] = :success
      flash[:result_text] = "Quantity updated!"
      redirect_to orders_path
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Quantity could not be updated"
      flash.now[:messages] = @order_product.errors.messages
      render :edit
    end
  end

  def destroy
    order = @order_product.order
    @order_product.destroy
    if order.order_products.empty?
      session.delete(:order_id)
    end
    redirect_to orders_path
  end

  private
  def op_params
    params.require(:order_product).permit(:quantity)
  end

  def find_op
    @order_product = OrderProduct.find_by(id: params[:id])
  end
end
