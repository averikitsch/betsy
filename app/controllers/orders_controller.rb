class OrdersController < ApplicationController
  before_action :find_order, only: [:index, :new, :show, :create, :update, :destroy]

  def index
    if @order
      @op = @order.order_products
    end
  end

  def show
    @order = Order.find_by(id: params[:id])
    unless @order
      render_404
    else
      users = @order.products.map{ |p| p.user}
      if !users.include?(@user)
        flash[:status] = :failure
        flash[:result_text] = "You can't view this page!"
        redirect_to users_path
      end
    end
  end

  def new
  end

  def update
    @order.update(order_params)
    unless @order.update(status: "paid")
      flash.now[:status] = :failure
      flash.now[:result_text] = "Boo!"
      flash.now[:messages] = humanize(@order.errors.messages)
      render :new, status: :bad_request
    else
      reduce_inventory(@order)
      session[:prev_order] = session[:order_id]
      session.delete(:order_id)
    end
  end

  def destroy
    @order = Order.find_by(id: session[:prev_order])
    unless @order.update(status: "cancelled")
      flash.now[:status] = :failure
      flash.now[:result_text] = "Boo! This cart couldn't be unsummoned!"
      flash.now[:messages] = humanize(@order.errors.messages)
      render :new, status: :bad_request
    else
      add_inventory(@order)
      # @order.destroy # if we choose to delete the order
      session.delete(:prev_order)
      redirect_to root_path
    end
  end

  def lookup
    @order = Order.new
  end

  def found
    @order = Order.where("id = ? AND name = ? AND email = ?",params[:id],params[:name],params[:email]).first
    unless @order
      flash.now[:status] = :failure
      flash.now[:result_text] = "Trick or Treat?! Not home!"
      render :lookup, status: :bad_request
    end
  end

  private

  def order_params
    return params.require(:order).permit(:name, :address, :email, :cc_num, :cc_expiry, :cc_cvv, :billing_zip)
  end

  def find_order
    @order = Order.find_by(id: session[:order_id])
  end

  def reduce_inventory(order)
    order.order_products.each do |order_product|
      product = Product.find_by(id: order_product.product_id)
      product.stock -= order_product.quantity
      product.save
    end
  end

  def add_inventory(order)
    order.order_products.each do |order_product|
      product = Product.find_by(id: order_product.product_id)
      product.stock += order_product.quantity
      product.save
    end
  end

  def humanize(hash)
    new_hash = {}
    hash.each do |k,v|
      new_hash[Order.human_attribute_name(k)] = hash[k]
    end
    return new_hash
  end
end
