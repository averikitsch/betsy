require "test_helper"

describe Order do
  before  do
    @order = Order.new(email: "hello@aol.com", address: "123 Main Street Seattle, WA 98101", name: "Lionel Ritchie", cc_num: "1234567890123456", cc_expiry: "10/19", cc_cvv: "123", billing_zip: "98101", status: "paid")
  end

  describe "validations" do
    it "must have an address" do
      @order.address = nil
      @order.valid?.must_equal false
    end

    it "must have a name corresponding with the credit card" do
      @order.name = nil
      @order.valid?.must_equal false
      @order.name = "Jane Doe"
      @order.valid?.must_equal true
    end

    it "must have an email address" do
      @order.email.must_equal "hello@aol.com"
      @order.valid?.must_equal true
      @order.email = nil
      @order.valid?.must_equal false
    end

    it "must have a credit card number which is 16 digits in length" do
      @order.cc_num.must_equal "1234567890123456"
      @order.valid?.must_equal true

      [nil,"45638","rejiwof",""].each do |num|
        @order.cc_num = num
        @order.valid?.must_equal false
      end
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
      [nil,"18294673","fuw"].each do |num|
        @order.cc_cvv = num
        @order.valid?.must_equal false
      end

      ["345","182","666"].each do |num|
        @order.cc_cvv = num
        @order.valid?.must_equal true
      end
    end

    it "must have a billing zip code that is numerical" do
      @order.billing_zip.must_equal "98101"
      @order.valid?.must_equal true

      [nil,"","fjeuil"].each do |num|
        @order.billing_zip = num
        @order.valid?.must_equal false
      end
    end

  end
end
