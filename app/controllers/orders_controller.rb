class OrdersController < ApplicationController
  def index
  end

  def show
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new order_params
    if @order.save
      
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def order_params
    return params.require(:order).permit(:name, :address, :email, :cc_num, :cc_expiry, :cc_cvv, :billing_zip)
  end
end
