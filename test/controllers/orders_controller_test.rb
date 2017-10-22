require "test_helper"

describe OrdersController do

  describe "order index" do
    it "should get index" do
      get orders_path
      must_respond_with :success
    end

    it "gets an order's products" do
      post order_products_path(products(:three), order_product: {quantity: 1})
      get orders_path
      must_respond_with :success
    end
  end

  # describe "order update" do
  #   it "can update an order" do
  #
  #   end
  #
  #   it "reduces inventory for a product" do
  #
  #   end
  # end

  describe "order destroy" do
    it "can delete an order" do
      proc {post order_products_path(products(:one), order_product: {quantity: 1})}.must_change 'Order.count', 1
      Order.last.order_products.count.must_equal 1
      proc {delete order_product_path(products(:one))}.must_change 'Order.count', -1
    end

    it "removes session with deletion" do
      post order_products_path(products(:one), order_product: {quantity: 1})
      session[:order_id].must_equal Order.last.id

      delete order_product_path(products(:one))
      # session[:order_id].must_equal nil
    end
  end

end
