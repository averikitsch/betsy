require "test_helper"

describe ProductsController do
  let(:one) {products(:one)}
  let(:two) {categories(:two)}
  let(:ghost) {users(:one)}

  describe "root index" do
    it "should get root path" do
      get root_path
      must_respond_with :success
    end
    it "should not error if there is no image" do
      one.image = nil
      one.save
      Product.create!(name: "averi", price:10,stock:100,user: users(:one))
      p Product.find_by(name: "averi")
      get root_path
      must_respond_with :success
      get products_path
      must_respond_with :success
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
    it "can access product new page" do
      get new_product_path()
      must_respond_with :success
    end
    it "should be able to create a new product with no categories" do
      proc {
        post products_path, params: {product: {
          name: "shoelace", price: 9.9, user_id: ghost.id, stock: 20
          }}
        }.must_change "Product.count", 1
        must_respond_with :redirect
      end

      it "should be able to create a new product with categories" do
        c_i = [categories(:one).id,categories(:two).id]
        proc {
          post products_path, params: {product: {
            name: "shoelace", price: 9.9, user_id: ghost.id, category_ids: c_i, stock: 20
            }}
          }.must_change "Product.count", 1
          must_respond_with :redirect
          product = Product.find_by(name: "shoelace")
          product.categories.length.must_equal 2
        end
        it "should rerender the form if it can't create a new product" do
          proc { post products_path, params: {product: {name: "shoelace"}}}.must_change "Product.count", 0
          must_respond_with :bad_request
        end
      end

      describe "update product" do
        it "should be able to update a product's information" do
          patch product_path(one), params: {product: {name: "New Name"}}
          updated_product = Product.find(one.id)
          updated_product.name.must_equal "New Name"
          must_redirect_to product_path
        end

        it "shouldn't update with bogus data" do
          patch product_path(one), params: {product: {name: ""}}
          updated_product = Product.find(one.id)
          updated_product.name.must_equal "sheet"
          must_respond_with :bad_request
        end

        it "should update categories" do
          c_i = [categories(:one).id,categories(:two).id]
            post products_path, params: {product: {
              name: "shoelace", price: 9.9, user_id: ghost.id, stock: 20
              }}
            must_respond_with :redirect
            product = Product.find_by(name: "shoelace")

            patch product_path(product.id), params: {product: { category_ids: c_i}}
            product.categories.count.must_equal 2

            patch product_path(product.id), params: {product: { category_ids: c_i}}
            product.categories.count.must_equal 2
          end
        end

        it "remove a category" do
          c_i = [categories(:one).id,categories(:two).id]
          post products_path, params: {product: {
              name: "shoelace", price: 9.9, user_id: ghost.id, stock: 20, category_ids: c_i
              }}
          product = Product.find_by(name: "shoelace")
          patch product_path(product.id), params: {product: { category_ids: []}}
              product.categories.length.must_equal 0
        end

        it "can toggle active" do
          product = products(:one)
          start = product.active

          patch toggle_active_path(product.id)
          must_respond_with :redirect
          product = Product.find_by(name: "sheet")
          product.active.must_equal !start
        end

        it "can toggle retired" do
          product = products(:one)
          product.active = true
          product.save
          start = product.active

          patch toggle_active_path(product.id)
          must_respond_with :redirect
          product = Product.find_by(name: "sheet")
          product.active.must_equal !start
        end

      
      end
