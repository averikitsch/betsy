require "test_helper"

describe ProductsController do
  let(:one) {products(:one)}
  let(:three) {products(:three)}
  let(:two) {categories(:two)}
  let(:ghost) {users(:one)}
  let(:ghoul) {users(:two)}

  before do
    login(ghost, :github)
  end

  describe "root index" do
    it "should get root path" do
      get root_path
      must_respond_with :success
    end

    it "should not error if there is no image" do
      one.image = nil
      one.save
      Product.create!(name: "averi", price:10,stock:100,user: users(:one))
      get root_path
      must_respond_with :success
      get products_path
      must_respond_with :success
    end

    it "should replace image if blank" do
      post products_path, params: {product: { user_id: ghost.id, name: "shoelace", price: 9.9,  stock: 20}}
      product = Product.find_by(name: "shoelace")
      product.image.must_equal "http://placebeyonce.com/200-300"
    end

    it "succeeds with no products" do
      Product.destroy_all
      get root_path
      must_respond_with :success
    end
  end

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

    it "should get search results" do
      get products_path, params: {search: "blood"}
      must_respond_with :success
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

    describe "guest access" do
      it "can't access product new page new product if not logged in" do
        delete logout_path
        get new_product_path
        must_respond_with :redirect
      end

      it "can't add a product if not logged in" do
        delete logout_path
        proc {post products_path, params: {product: { user_id: ghost.id, name: "shoelace", price: 9.9,  stock: 20}}}.must_change "Product.count", 0
      end
    end

    describe "user access" do
      it "can access product new page when logged in" do
        get new_product_path()
        must_respond_with :success
      end

      it "should be able to create a new product with no categories" do
        proc {post products_path, params: {product: { user_id: ghost.id, name: "shoelace", price: 9.9,  stock: 20}}}.must_change "Product.count", 1
        must_respond_with :redirect
      end

      it "should be able to create a new product with categories" do
        c_i = [categories(:one).id,categories(:two).id]
        proc {post products_path, params: {product: { name: "shoelace", price: 9.9, user_id: ghost.id, category_ids: c_i, stock: 20, image: ""}}}.must_change "Product.count", 1
        must_respond_with :redirect
        product = Product.find_by(name: "shoelace")
        product.categories.length.must_equal 2
        product.image.must_equal "http://placebeyonce.com/200-300"
      end

      it "should rerender the form if it can't create a new product" do
        proc { post products_path, params: { product: {user_id: ghost.id }}}.must_change "Product.count", 0
        must_respond_with :bad_request
      end

      it "should not allow a user to create a new product for another user" do
        #ghost (user one in yml) is currently logged in
        proc { post products_path, params: {product: {name: "shoelace", price: 12.3, user_id: ghoul.id}}}.must_change "Product.count", 0
        must_respond_with :bad_request
        product2 = Product.find_by(name: "tomb")
        product2.active.must_equal false
      end

    end
  end

  describe "update product" do
    it "should be able to update a product's information" do
      patch product_path(one), params: {product: {name: "New Name"}}
      updated_product = Product.find(one.id)
      updated_product.name.must_equal "New Name"
      must_redirect_to product_path
    end

    it "should be able to update a product's information" do
      delete logout_path
      login(users(:two),"github")
      patch product_path(one), params: {product: {name: "New Name"}}
      must_respond_with :redirect
    end

    it "shouldn't update with bogus data" do
      patch product_path(one), params: {product: {name: ""}}
      updated_product = Product.find(one.id)
      updated_product.name.must_equal "sheet"
      must_respond_with :bad_request
    end

    it "should update categories" do
      c_i = [categories(:one).id,categories(:two).id]
      post products_path, params: {product: { name: "shoelace", price: 9.9, user_id: ghost.id, stock: 20}}
      must_respond_with :redirect
      product = Product.find_by(name: "shoelace")

      patch product_path(product.id), params: {product: { category_ids: c_i}}
      product.categories.count.must_equal 2
    end

    it "can't view edit product page if not the logged in" do
      delete logout_path
      session[:user_id].must_be_nil
      get edit_product_path(one)
      must_respond_with :redirect
    end

    it "can't view edit page for another user's product" do
      get edit_product_path(three)
      must_respond_with :redirect
    end

    it "should not allow a user to edit a product for another user" do
      #ghost (user one in yml) is currently logged in
      #product three belongs to user ghoul
      patch product_path(three), params: {product: {name: "this won't get updated"}}
      not_updated = Product.find(three.id)
      not_updated.name.must_equal "tomb"
      must_redirect_to product_path
    end

  end

  it "removes a category" do
    c_i = [categories(:one).id,categories(:two).id]
    post products_path, params: {product: {name: "shoelace", price: 9.9, user_id: ghost.id, stock: 20, category_ids: c_i}}
    product = Product.find_by(name: "shoelace")
    patch product_path(product.id), params: {product: { category_ids: []}}
    product.categories.length.must_equal 0
  end

  describe "it can toggle a retired or active product" do

    describe "user functionality" do
      it "can toggle active" do
        product = products(:one)
        product.active.must_equal false
        patch toggle_active_path(product.id)
        must_respond_with :redirect
        product = Product.find_by(name: "sheet")
        product.active.must_equal true
      end
      it "can toggle retired" do
        product = products(:one)
        product.active.must_equal false
        product.active = true
        product.active.must_equal true
        product.save
        patch toggle_active_path(product.id)
        must_respond_with :redirect
        product = Product.find_by(name: "sheet")
        product.active.must_equal false
      end
      it "won't allow a user to toggle another user's product" do
        #ghost is currently logged in (user one in yml)
        #product2 belongs to user two
        product2 = products(:three)
        product2.active.must_equal false
        patch toggle_active_path(product2.id)
        must_respond_with :bad_request
        product2 = Product.find_by(name: "tomb")
        product2.active.must_equal false
      end

    end

    describe "guest functionality" do
      it "will not toggle active" do
        product = products(:one)
        product.active.must_equal false
        delete logout_path

        patch toggle_active_path(product.id)
        must_respond_with :bad_request
        product = Product.find_by(name: "sheet")
        product.active.must_equal false
      end
      it "will not toggle retire" do
        product = products(:one)
        product.active.must_equal false
        product.active = true
        product.save
        product.active.must_equal true
        delete logout_path

        patch toggle_active_path(product.id)
        must_respond_with :bad_request
        product = Product.find_by(name: "sheet")
        product.active.must_equal true
      end
      it "will not toggle active" do
        product = products(:one)
        product.active.must_equal false
        delete logout_path

        patch toggle_active_path(product.id)
        must_respond_with :bad_request
        product = Product.find_by(name: "sheet")
        product.active.must_equal false
      end
    end

  end

end
