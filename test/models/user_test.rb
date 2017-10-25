require "test_helper"

describe User do
  let(:user) { User.new }
  let(:one) { users(:one) }

  describe "validations" do
    it "must be valid" do
      one.must_be :valid?
    end

    it "must have a username" do
      user.email = "email"
      user.username = "   "
      user.valid?.must_equal false

      user.username = "Name"
      user.valid?.must_equal true
    end

    it "username must be unique" do
      one.username.must_equal "ghost"
      user.email = "email2"
      user.username = "ghost"
      user.valid?.must_equal false
    end

    it "must have an email" do
      user.username = "username"
      user.email = "    "
      user.valid?.must_equal false

      user.email = "email3"
      user.valid?.must_equal true
    end

    it "email must be unique" do
      one.email.must_equal "ghost@paranormal.com"
      user.username = "name2"
      user.username = "ghost@paranormal.com"
      user.valid?.must_equal false
    end
  end

  describe "orders" do
    it "must return a collection of orders associated with the user" do
      users(:two).orders.size.must_equal 3
    end

  end

  describe "order_prducts" do
    it "must return a collection of order_products" do
      users(:two).order_products.size.must_equal 2
    end

    it "must have only order_products associated with the user" do
      products = users(:two).order_products.collect { |order_product| Product.find_by(id: order_product.product_id) }
      products.each { |product| product.user_id.must_equal users(:two).id }
    end

    it "must only return order_products from an order with a status of paid or complete" do
      order_statuses = users(:two).order_products.collect { |order_product| Order.find_by(id: order_product.order_id).status }
      order_statuses.each { |order_status| ["paid", "complete"].must_include order_status  }
    end
  end

  describe "total_revenue" do
    it "returns the amount of all order_products associated with the user" do
      users(:two).total_revenue.must_equal 79.92
    end
  end
end
