require "test_helper"

describe OrdersController do
  let(:new_order) {post order_products_path(products(:three), order_product: {quantity: 1})}

  describe "order index" do
    it "should get index" do
      get orders_path
      must_respond_with :success
    end

    it "gets an order's products" do
      new_order
      get orders_path
      must_respond_with :success
    end
  end

  describe "order show" do
    it "should get show if logged in" do
      login(users(:one),"github")
      get order_path(orders(:two))
      must_respond_with :redirect

      get order_path(orders(:one))
      order_id = orders(:one).id
      orders(:one).destroy

      get order_path(order_id)
      must_respond_with :not_found

    end
    it "should get show" do
      get order_path(orders(:one))
      must_respond_with :redirect
    end
  end

  describe "order update" do
    it "can update an order" do
      new_order
      variables = %w(name email address cc_num cc_expiry cc_cvv billing_zip)
      values = %w(name email@email.com address 1111222233334444 10/20 666 98101)

      variables.each do |variable|
        Order.last[variable].must_be_nil
      end

      Order.last.status.must_equal 'pending'

      put order_path(Order.last), params: {order:
        {name: "name", email: "email@email.com", address: "address",
          cc_num: "1111222233334444", cc_expiry: "10/20", cc_cvv: "666", billing_zip: "98101" }}

      must_respond_with :success

      variables.zip(values).each do |variable, value|
        Order.last[variable].must_equal value
      end

      Order.last.status.must_equal 'paid'
    end

    it "order status doesn't change until all inputs entered" do
      new_order
      Order.last.status.must_equal 'pending'

      put order_path(Order.last), params: {order: {name: "name"}}
      must_respond_with :bad_request
      Order.last.status.must_equal 'pending'
    end

    it "reduces inventory for an order" do
      new_order
      products(:three).stock.must_equal 100

      put order_path(Order.last), params: {order:
        {name: "name", email: "email@email.com", address: "address",
          cc_num: "1111222233334444", cc_expiry: "10/20", cc_cvv: "666", billing_zip: "98101" }}

      Order.last.status.must_equal 'paid'
      session[:order_id].must_be_nil
      Product.find_by(name: "tomb").stock.must_equal 99
    end
  end

  describe "order destroy" do
    let(:delete_product) {delete order_product_path(products(:one))}

    it "removes session with deletion" do
      delete order_product_path(order_products(:one))
      session[:order_id].must_be_nil
    end

    it "can 'cancel' and order" do
      new_order
      put order_path(Order.last), params: {order:
        {name: "name", email: "email@email.com", address: "address",
          cc_num: "1111222233334444", cc_expiry: "10/20", cc_cvv: "666", billing_zip: "98101" }}
      Order.last.status.must_equal 'paid'

      delete order_path(Order.last)
      Order.last.status.must_equal 'cancelled'
    end

    it "adds inventory back to a cancelled order" do
      new_order
      products(:three).stock.must_equal 100

      put order_path(Order.last), params: {order:
        {name: "name", email: "email@email.com", address: "address",
          cc_num: "1111222233334444", cc_expiry: "10/20", cc_cvv: "666", billing_zip: "98101" }}
      Product.find_by(name: "tomb").stock.must_equal 99

      delete order_path(Order.last)
      Product.find_by(name: "tomb").stock.must_equal 100
    end

    it "can get lookup" do
      get orders_lookup_path
      must_respond_with :success
    end

    it "can get found" do
      get orders_found_path params: {id: 1}
      must_respond_with :bad_request
    end

  end

end
