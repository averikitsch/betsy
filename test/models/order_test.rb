require "test_helper"

describe Order do
  before  do
    @order = Order.new(email: "hello@aol.com", address: "123 Main Street Seattle, WA 98101", name: "Lionel Ritchie", cc_num: "1234567890123456", cc_expiry: "10/19", cc_cvv: "123", billing_zip: "98101", status: "paid")

    # @order.order_products << order_products(:one)

  end

  describe "validations" do
    it "must have an address" do
      @order.address = nil
      @order.valid?.must_equal false
    end

    # it "must have a default status of pending" do
    #   @order.status.must_equal "pending"
    # end

    # it "must have at least one OrderProduct" do
    #   @order.order_products = []
    #   @order.valid?.must_equal false
    #   @order.order_products << order_products(:one)
    #   @order.valid?.must_equal true
    # end

    it "must have a name corresponding with the credit card" do
      @order.name = nil
      @order.valid?.must_equal false
      @order.name = "Jane Doe"
      @order.valid?.must_equal true
    end

    it "must have an email address" do
      @order.email = nil
      @order.valid?.must_equal false
      @order.email = "fake@gmail.com"
      @order.valid?.must_equal true
    end

    it "must have a credit card number which is 16 digits in length" do
      @order.cc_num = nil
      @order.valid?.must_equal false
      @order.cc_num = "45638"
      @order.valid?.must_equal false
      @order.cc_num = "rejiwof"
      @order.valid?.must_equal false
      @order.cc_num = "1234567890123456"
      @order.valid?.must_equal true
    end

    it "must have a credit card expiration date that is not in the past" do
      [nil,"","09/17","09,17"].each do |num|
        @order.cc_expiry = num
        @order.valid?.must_equal false
      end

      ["09/18","11/20","9/18"].each do |num|
        @order.cc_expiry = num
        @order.valid?.must_equal true
      end
    
    end

    it "must have a three-digit credit card CVV number" do
      @order.cc_cvv = nil
      @order.valid?.must_equal false
      @order.cc_cvv = "18294673"
      @order.valid?.must_equal false
      @order.cc_cvv = "fuw"
      @order.valid?.must_equal false
      @order.cc_cvv = "345"
      @order.valid?.must_equal true
    end

    it "must have a billing zip code that is numerical" do
      @order.billing_zip = nil
      @order.valid?.must_equal false
      @order.billing_zip = "fjeuil"
      @order.valid?.must_equal false
      @order.billing_zip = "98101"
      @order.valid?.must_equal true
    end


  end
end
