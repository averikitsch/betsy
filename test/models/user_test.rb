require "test_helper"

describe User do
  let(:user) { User.new }
  let(:one) { users(:one) }

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

  describe "order_prducts" do
    it "must return an array of order_products" do
      # users(:two).order_products.class.must_equal Array
      users(:two).order_products.size.must_equal 2
    end

    it "must have only order_products associated with the user" do
      products = users(:two).order_products.collect { |order_product| Product.find_by(id: order_product.product_id) }
      products.each { |product| product.user_id.must_equal users(:two).id }
    end
  end

  describe "total_revenue" do
    it "returns the amount of all order_products associated with the user" do
      users(:two).total_revenue.must_equal 39.96
    end
  end
end
