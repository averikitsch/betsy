require "test_helper"

describe OrderProductsController do
  it "should create a new order and set session when the first product is added to the cart" do
    order_count = Order.count
    post order_products_path(products(:one), order_product: {quantity: 1})
    session[:order_id].must_equal Order.last.id
    Order.count.must_equal order_count + 1
  end

  it "shouldn't create a new order product with bad data" do
    proc{post order_products_path(products(:one), order_product: {quantity: -1})}.must_change 'OrderProduct.count', 0
    proc{post order_products_path(products(:one), order_product: {quantity: ""})}.must_change 'OrderProduct.count', 0
  end

  it "should make a new order if session is broken" do
    login(users(:one), :github)
    post order_products_path(products(:one), order_product: {quantity: 1})
    startID = session[:order_id]


    Order.destroy_all

    post order_products_path(products(:one), order_product: {quantity: 1})

    session[:order_id].wont_equal startID
    Order.count.must_equal 1
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
    # start_qty = order_products(:two).quantity
    proc{post order_products_path(products(:two)), params: {order_product: {quantity: 5}}}.must_change 'OrderProduct.count', 0
    must_respond_with :bad_request
  end

  it "updates the quantity if product is already added" do
    post order_products_path(products(:two)), params: {order_product: {quantity: 1}}
    start_op = OrderProduct.last.quantity
    proc{post order_products_path(products(:two)), params: {order_product: {quantity: 1}}}.must_change 'OrderProduct.count', 0
    OrderProduct.last.quantity.must_equal start_op+1
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
    delete order_product_path(order_products(:three))
    session[:order_id].must_be_nil
    Order.count.must_equal order_count - 1
  end

  it "won't update cart quantity with bad data" do
    post order_products_path(products(:two)), params: {order_product: {quantity: 1}}
    start_op = OrderProduct.last.quantity

    proc{patch order_product_path(products(:two)), params: {order_product: {quantity: 1000}}}.must_change 'OrderProduct.count', 0

    OrderProduct.last.quantity.must_equal start_op
  end

  it "should mark order as complete if all items are shipped" do
    login(users(:one), :github)
    one = order_products(:one)
    three = order_products(:three)

    patch ship_order_product_path(one.id)
    delete logout_path
    login(users(:two), :github)
    patch ship_order_product_path(three.id)

    OrderProduct.find(three.id).shipped.must_equal true
    one.order.status.must_equal "complete"
    must_respond_with :redirect
  end

  it "should toggle shipped" do
    login(users(:one), :github)
    one = order_products(:one)
    start = one.shipped

    patch ship_order_product_path(one.id)

    OrderProduct.find(one.id).shipped.must_equal !start
  end

  it "should cancel an order-product" do
    login(users(:one), :github)
    one = order_products(:one)
    start = one.cancelled

    patch cancel_order_product_path(one.id)

    OrderProduct.find(one.id).cancelled.must_equal !start
  end

  it "if all op are cancelled order is cancelled" do
    login(users(:one), :github)
    one = order_products(:one)
    three = order_products(:three)
    patch cancel_order_product_path(one.id)
    puts OrderProduct.find(one.id).cancelled
    delete logout_path
    login(users(:two), :github)
    patch cancel_order_product_path(three.id)
    puts OrderProduct.find(three.id).cancelled
    one.order.status.must_equal "cancelled"
    must_respond_with :redirect
  end

  it "can't mark cancel if shipped" do
    login(users(:one), :github)
    one = order_products(:one)
    start = one.cancelled

    patch ship_order_product_path(one.id)

    OrderProduct.find(one.id).cancelled.must_equal start
  end

  it "can't mark shipped if cancelled" do
    login(users(:one), :github)
    one = order_products(:one)
    start = one.shipped
    patch cancel_order_product_path(one.id)

    OrderProduct.find(one.id).shipped.must_equal start
    must_respond_with :redirect
  end

  it "can't mark shipped or cancelled if not logged in" do
    patch cancel_order_product_path(order_products(:one))
    must_respond_with :redirect
    patch ship_order_product_path(order_products(:one))
    must_respond_with :redirect
  end

  it "can't mark shipped or cancelled if not owner" do
    login(users(:two), :github)
    patch cancel_order_product_path(order_products(:one))
    must_respond_with :redirect
    patch ship_order_product_path(order_products(:one))
    must_respond_with :redirect
  end
end
