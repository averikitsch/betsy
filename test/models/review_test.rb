require "test_helper"

describe Review do
  let(:review) { Review.new }
  let(:one) { reviews(:review1) }

  it "must be valid" do
    one.must_be :valid?
  end

  it "rating must be present" do
    one.rating = "     "
    one.valid?.must_equal false

    one.rating = 2
    one.valid?.must_equal true
  end

  it "has relationship to product" do
    one.product.must_equal products(:one)
    one.product_id.must_equal products(:one).id
  end

  it "must be between 1-5" do
    (1..5).each do |n|
      review = Review.new(rating: n, product: products(:one))
      review.valid?.must_equal true
    end
  end

  it "it can't have rating over 5 or less than 1" do
    [-1,6,0,10,100].each do |n|
      review = Review.new(rating: n, product: products(:one))
      review.valid?.must_equal false
    end
  end
end
