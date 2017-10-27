require "test_helper"

describe OrderProduct do
  let(:order_product) { OrderProduct.new(order: orders(:one), product: products(:one), quantity: 7) }

  describe "order product validations" do
    it "must have a positive integer quantity" do
      [nil, "eight", -3, "", 0].each do |num|
        order_product.quantity = num
        order_product.valid?.must_equal false
      end
      (1..5).each do |num|
        order_product.quantity = num
        order_product.valid?.must_equal true
      end
    end
    it "must be in stock" do
      order_product.quantity = 100
      order_product.valid?.must_equal false
    end
    it "can't make an order product from out of stock product" do
      product = products(:one)
      product.stock = 0
      product.save
      op = OrderProduct.new(order: orders(:one), product: products(:one), quantity: 7)
      op.valid?.must_equal false
    end
  end

  describe "relations" do
    it "has an associated product" do
      op = order_products(:one)
      op.product.must_equal products(:one)
      op.product_id = products(:two).id
      op.product.must_equal products(:two)
    end

    it "has associated order" do
      op = order_products(:one)
      op.order.must_equal orders(:one)
      op.order_id = orders(:two).id
      op.order.must_equal orders(:two)
    end
  end
end
