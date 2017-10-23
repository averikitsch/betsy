require "test_helper"

describe ProductsController do
  let(:one) {products(:one)}
  let(:two) {categories(:two)}
  let(:ghost) {users(:one)}

  describe "products index" do
    it "should get the products index" do
      get products_path
      must_respond_with :success
    end
    it "should get a user's products index" do
      get user_products_path(one)
      must_respond_with :success
    end
    it "should render a 404 if user id doesn't exist" do
      get user_products_path(999)
      must_respond_with :not_found
    end
    it "should get a category's products index" do
      one.category_ids = two.id
      get category_products_path(two.id)
      must_respond_with :success
    end
    it "should render a 404 if category id doesn't exist" do
      get category_products_path(999)
      must_respond_with :not_found
    end
  end

  describe "show product page" do
    it "gets an individual product page" do
      get product_path(one.id)
      must_respond_with :success
    end
    it "should render a 404 if product doesn't exist" do
      get product_path(999)
      must_respond_with :not_found
    end
  end

  describe "create product" do
    it "should be able to create a new product" do
      proc {
        post products_path, params: {product: {
          name: "shoelace", price: 9.9, user_id: ghost.id
          }}
        }.must_change "Product.count", 1
      must_respond_with :redirect
    end
    # it "should rerender the form if it can't create a new product" do
    #   proc { post products_path, params: {product: {name: "shoelace"}}}.must_change "Product.count", 0
    #   must_respond_with :success
    # end
  end

  describe "update product" do
    # it "should be able to update a product's information" do
    #   patch product_path(one), params: {product: {name: "New Name"}}
    #   updated_product = Product.find(one.id)
    #   updated_product.name.must_equal "New Name"
    #   must_redirect_to product_path
    # end
  end

end
