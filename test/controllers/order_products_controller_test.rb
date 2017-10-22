require "test_helper"

describe OrderProductsController do
  it "should create a new order and set session when the first product is added to the cart" do
    order_count = Order.count
    post order_products_path(products(:one), order_product: {quantity: 1})
    session[:order_id].must_equal Order.last.id
    Order.count.must_equal order_count + 1
  end

  it "edit should get the edit form" do
    get edit_order_product_path(order_products(:one))
    must_respond_with :success
  end

  it "should update the quantity in the cart" do
    patch order_product_path(order_products(:one)), params: {order_product: {quantity: 3}}
    OrderProduct.find_by(id: order_products(:one).id).quantity.must_equal 3
  end

  it "should not let the order quantity exceed the available stock" do
    start_qty = order_products(:two).quantity
    patch order_product_path(order_products(:two)), params: {order_product: {quantity: 5}}
  end

  it "should delete an order_product from the cart" do
    order = Order.find_by(id: orders(:two))
    product_count = order.order_products.count
    delete order_product_path(order_products(:two))
    must_redirect_to orders_path
    order.order_products.count.must_equal (product_count - 1)
  end

  it "should clear the session and delete the order if all order_products are deleted" do
    order_count = Order.count
    delete order_product_path(order_products(:one))
    Order.count.must_equal order_count - 1
    session[:order_id].must_equal nil
  end

end
