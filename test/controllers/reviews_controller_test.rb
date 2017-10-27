require "test_helper"

describe ReviewsController do
  describe "logged in" do
    it "won't let the product's owner to review product" do
      login(users(:one), :github)
      get new_product_review_path(products(:one))
      must_respond_with :redirect

      post product_reviews_path(products(:one)), params: {rating: 5}
      must_respond_with :redirect
    end

    it "will let other users vote for a product" do
      login(users(:one), :github)
      get new_product_review_path(products(:two))
      must_respond_with :success

      proc{post product_reviews_path(products(:two)), params: {rating: 5}}.must_change 'Review.count', 1
      must_respond_with :redirect
    end

  end

  describe "logged out" do

    it "should get a new form" do
      get new_product_review_path(products(:one))
      must_respond_with :success
    end

    it "renders 404 not_found " do
      get new_product_review_path(-1)
      must_respond_with :not_found
    end

    it "should be able to create a review" do
      product = products(:two)
      start = product.reviews.count
      post product_reviews_path(product.id), params: {rating: 5, body: "la la la"}
      product.reviews.count.must_equal start+1
      must_respond_with :redirect
      must_redirect_to product_path(product.id)
    end

    it "it won't create a review with bad data" do
      product = Product.create(name:"kitty",price: 10, user: users(:one), stock: 10)
      start = product.reviews.count
      post product_reviews_path(product.id), params: {review:{rating: 15, body: "la la la"}}
      product.reviews.count.must_equal start
      must_respond_with :bad_request
    end
  end
end
