require "test_helper"

describe ProductsHelper do
  let(:three) { products(:three)}
  let(:one) { categories(:one)}
  let(:two) { categories(:two)}
  let(:review1) { reviews(:review1)}
  let(:review2) { reviews(:review2)}
  let(:review3) { reviews(:review3)}

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
  describe "print categories" do
    it "strings together a list of categories" do
      array = [one, two]
      print_categories(array).must_equal "potions, accessories"
    end
  end
  describe "average rating method" do
    it "calculates an average rating" do
      array = [review3, review2, review1]
      average_rating(array).must_equal "2.7 out of 5"
    end
  end
end
