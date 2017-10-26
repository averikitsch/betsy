class OrderProductsController < ApplicationController
  before_action :find_op, only: [:edit, :update, :destroy, :shipped, :cancel]

  def create
    if session[:order_id].nil?
      @order = Order.create(status: "pending")
      session[:order_id] = @order.id
    else
      @order = Order.find_by(id: session[:order_id])
      if @order.nil? # broken session (ie no cart but session still in browser cache)
        @order = Order.create(status: "pending")
        session[:order_id] = @order.id
      end
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
      flash[:result_text] = "Successfully summoned to your treat bag!"
      redirect_to product_path(params[:id])
    else
      flash[:status] = :failure
      flash[:result_text] = "Boo!"
      flash[:messages] = @op.errors.messages
      redirect_to product_path(params[:id]), status: :bad_request
    end
  end

  def edit
  end

  def update
    if @order_product.update(op_params)
      flash[:status] = :success
      flash[:result_text] = "Scares updated!"
      redirect_to orders_path
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Scares could not be updated"
      flash.now[:messages] = @order_product.errors.messages
      render :edit
    end
  end

  def destroy
    order = @order_product.order
    @order_product.destroy
    if order.order_products.empty?
      order.destroy
      session.delete(:order_id)
    end
    flash[:status] = :success
    flash[:result_text] = "Successfully disappeared from your coffin!"
    redirect_to orders_path
  end

  def shipped
    if find_user
      if @order_product.product.user.id == session[:user_id]
        if !@order_product.cancelled
          @order_product.update_attributes(shipped: @order_product.shipped ? false : true)

          order = @order_product.order
          ops = order.order_products
          all_op = ops.map { |op| op.shipped }
          unless all_op.include?(false)
            #if all op are shipped mark order as complete
            order.update(status: "complete")
          end
          flash[:status] = :success
          flash[:result_text] = @order_product.shipped ? "Successfully shipped!" : "Shipping cancelled!"
          redirect_to user_orders_path(session[:user_id])
        else
          flash[:status] = :failure
          flash[:result_text] = "You can't ship a cancelled item!"
          redirect_to user_orders_path(session[:user_id])
        end
      else
        flash[:status] = :failure
        flash[:result_text] = "You don't have access to this order item!"
        redirect_to root_path
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "You don't have access to this order item!"
      redirect_to root_path
    end
  end

  def cancel
    if find_user
      if @order_product.product.user.id == session[:user_id]
        if !@order_product.shipped
          @order_product.update_attributes(cancelled: @order_product.cancelled ? false : true)
          order = @order_product.order
          ops = order.order_products
          all_op = ops.map { |op| op.cancelled }
          unless all_op.include?(false)
            #if all op are shipped mark order as complete
            order.update(status: "cancelled")
          end
          flash[:status] = :success
          flash[:result_text] = @order_product.cancelled ? "Successfully cancelled!" : "Reactivated order item"
          redirect_to user_orders_path(session[:user_id])
        else
          flash[:status] = :failure
          flash[:result_text] = "You can't cancel a shipped item"
          redirect_to user_orders_path(session[:user_id])
        end
      else
        flash[:status] = :failure
        flash[:result_text] = "You don't have access to this order item!"
        redirect_to root_path
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "You don't have access to this order item!"
      redirect_to root_path
    end
  end

  private
  def op_params
    params.require(:order_product).permit(:quantity)
  end

  def find_op
    @order_product = OrderProduct.find_by(id: params[:id])
  end
end
