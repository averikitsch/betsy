class OrderProductsController < ApplicationController
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
    end
    @op = OrderProduct.new(op_params)
    @op.product_id = params[:id]
    @op.order_id =  session[:order_id]
    if @op.save
      flash[:success] = :success
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
    @order_product = OrderProduct.find_by(id: params[:id])
  end

  def update
  end

  def destroy
  end

  private
  def op_params
    params.require(:order_product).permit(:quantity)
  end
end
