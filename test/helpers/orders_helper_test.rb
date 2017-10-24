require "test_helper"

  describe OrdersHelper do
    #an order should have order_products
    it "test helper methods" do
      order = orders(:one)
      price = products(:one).price * order_products(:one).quantity + products(:three).price * order_products(:three).quantity
      puts price
      puts order.order_products
      subtotal(order.order_products).must_equal price
      total(subtotal(order.order_products)).must_equal price*1.10
    end

    it "tests hider cc_num function" do
      num = "1234 1234"
      hide_num(num).must_equal "**** 1234"
      num = "12341234"
      hide_num(num).must_equal "****1234"
      num = "123412341234"
      hide_num(num).must_equal "********1234"
    end
  end
