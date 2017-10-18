require "test_helper"

describe OrderProduct do
  let(:order_product) { OrderProduct.new(order: orders(:one), product: products(:one), quantity: 7) }

  describe "order product validations" do
  it "must have a positive integer quantity" do
    order_product.quantity = nil
    order_product.valid?.must_equal false
    order_product.quantity = "eight"
    order_product.valid?.must_equal false
    order_product.quantity = -3
    order_product.valid?.must_equal false
    order_product.quantity = 6
    order_product.valid?.must_equal true
  end

  # it "must have a default shipped value of false" do
  #   order_product.shipped.must_equal false
  # end

  it "must have an associated order" do
    order_product.order_id = nil
    order_product.valid?.must_equal false
    order_product.order_id = orders(:one).id
    order_product.valid?.must_equal true
  end

  it "must have an associated product" do
    order_product.product_id = nil
    order_product.valid?.must_equal false
    order_product.product_id = products(:one).id
    order_product.valid?.must_equal true
  end
end
end
