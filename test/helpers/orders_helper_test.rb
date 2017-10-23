require "test_helper"

  describe OrdersHelper do
    #an order should have order_products
    it "test helper methods" do
      order = orders(:one)
      price = products(:one).price * order_products(:one).quantity
      subtotal(order.order_products).must_equal price
      total(subtotal(order.order_products)).must_equal price*1.10
    end
  end
