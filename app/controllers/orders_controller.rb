class OrdersController < ApplicationController
  def index
    @order = Order.find_by(id: session[:order_id])
    if @order
      @op = @order.order_products
    end
  end

  def show
  end

  def new
    @order = Order.find(session[:order_id])
  end

  def create
    @order = Order.find(session[:order_id])
    # @order.write_attribute(order_params)
    # unless @order.update(status: "paid")
    #   flash.now[:status] = :failure
    #   flash.now[:result_text] = "Oops!"
    #   flash.now[:messages] = @order.errors.messages
    #   render :new
    # end
  end

  def edit
  end

  def update
    @order = Order.find(session[:order_id])
    @order.update(order_params)
    unless @order.update(status: "paid")
      flash.now[:status] = :failure
      flash.now[:result_text] = "Oops!"
      flash.now[:messages] = @order.errors.messages
      render :new
    end
  end

  def destroy
  end

  private

  def order_params
    return params.require(:order).permit(:name, :address, :email, :cc_num, :cc_expiry, :cc_cvv, :billing_zip)
  end
end
