require "test_helper"

describe Review do
  let(:review) { Review.new }
  let(:one) { reviews(:one) }
  let(:two) { products(:two) }

  it "must be valid" do
    one.must_be :valid?
  end

  it "rating must be present" do
    review.product_id = two.id
    review.rating = "     "
    review.valid?.must_equal false

    review.rating = 2
    review.valid?.must_equal true
  end
end
