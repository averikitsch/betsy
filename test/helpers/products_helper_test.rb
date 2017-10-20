require "test_helper"

describe ProductsHelper do
  let(:three) { products(:three)}

  describe "stock method" do
    it "returns 'in stock' if stock number is more than 10" do
      three.stock.must_equal 100
      stock(three.stock).must_equal "in stock"
    end
    it "returns 'limited stock' if stock number is in between 0 and 10" do
      three.stock = 3
      three.stock.must_equal 3
      stock(three.stock).must_equal "limited stock"
    end
    it "returns 'out of stock' if stock number is 0" do
      three.stock = 0
      three.stock.must_equal 0
      stock(three.stock).must_equal "out of stock"
    end
    it "returns 'out of stock' if stock number is negative" do
      three.stock = -1
      three.stock.must_equal (-1)
      stock(three.stock).must_equal "out of stock"
    end
  end
end
