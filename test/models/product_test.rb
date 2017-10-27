require "test_helper"

describe Product do
  let(:product) { Product.new }
  let(:valid_product) {products(:valid_product)}
  let(:one) {products(:one)}
  let(:two) {users(:two)}

  it "must belong to a user" do
    valid_product.valid?.must_equal false
    valid_product.errors.keys.must_include :user
  end

  it "must have a name to be valid" do
    one.valid?.must_equal true
    one.name = ""
    one.valid?.must_equal false
  end

  it "must have a unique name" do
    product = products(:two)
    product.name = products(:one).name
    product.valid?.must_equal false
  end

  it "must have a price" do
    product = products(:two)
    product.valid?.must_equal true

    [nil,"",0,"hello"].each do |num|
      product.price = num
      product.valid?.must_equal false
    end
  end

  it "must have a numerical price value" do
    product.user_id = two.id
    product.price = 10
    product.name = "unique name"

    product.stock = 5
    product.valid?.must_equal true

    product.price = "clearly not a number"
    product.valid?.must_equal false
  end

  it "must have a price value greater than 0" do
    product.user_id = two.id
    product.price = 10
    product.name = "unique name"

    product.stock = 1
    product.valid?.must_equal true

    product.price = -5
    product.valid?.must_equal false
  end

  it "has stock to be valid" do
    product = products(:two)
    product.valid?.must_equal true

    [nil,"",-10].each do |num|
      product.stock = num
      product.valid?.must_equal false
    end
  end

  it "can have 0 stock" do
    product = products(:two)
    product.stock = 0
    product.valid?.must_equal true
  end
end
