class OrdersController < ApplicationController
  def index
    @order = Order.find(session[:order_id])
    @op = @order.order_products
  end

  def show
  end

  def new
    @order = Order.find(session[:order_id])
  end

  def create
    @order = Order.find(session[:order_id])
    if @order.update_attributes(order_params, status: "paid")
    # @order.status = "paid"
    #  if @order.save

    else
      render :new
    end
  end

  def edit
  end

  def update
    @order = Order.find(session[:order_id])
  end

  def destroy
  end

  private

  def order_params
    return params.require(:order).permit(:name, :address, :email, :cc_num, :cc_expiry, :cc_cvv, :billing_zip)
  end
end
