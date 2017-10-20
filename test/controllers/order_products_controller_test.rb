require "test_helper"

describe OrderProductsController do
  # it "should get index" do
  #   get order_products_index_url
  #   value(response).must_be :success?
  # end
  #
  # it "should get show" do
  #   get order_products_show_url
  #   value(response).must_be :success?
  # end
  #
  # it "should get new" do
  #   get order_products_new_url
  #   value(response).must_be :success?
  # end
  #
  # it "should get create" do
  #   get order_products_create_url
  #   value(response).must_be :success?
  # end

  it "edit should get the edit form" do
    get edit_order_product_path(order_products(:one))
    must_respond_with :success
  end

  it "should update the quantity in the cart" do
    patch order_product_path(order_products(:one)), params: {order_product: {quantity: 0} }
    puts OrderProduct.find_by(id: order_products(:one)).quantity
    order_product = OrderProduct.find_by(id: order_products(:one))
    order_product.quantity.must_equal 0
  end

  it "should not let the order quantity exceed the available stock" do

  end

  it "should delete an order_product from the cart" do
    order = Order.find_by(id: orders(:two))
    product_count = order.order_products.count
    delete order_product_path(order_products(:two))
    must_redirect_to orders_path
    order.order_products.count.must_equal (product_count - 1)
  end

  it "should clear the order if all order_products are deleted" do

  end

end
