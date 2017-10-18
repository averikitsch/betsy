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
    two.valid?.must_equal true
    valid_product.user_id = two.id
    valid_product.valid?.must_equal true
  end
  it "must have a unique name" do
    product.user_id = two.id
    product.price = 10
    product.name = "unique name"
    product.valid?.must_equal true
    product.name = products(:valid_product).name
    product.valid?.must_equal false
  end
  it "must have a price" do
    product.user_id = two.id
    product.price = 10
    product.name = "unique name"
    product.valid?.must_equal true
    product.price = nil
    product.valid?.must_equal false
  end
  it "must have a numerical price value" do
    product.user_id = two.id
    product.price = 10
    product.name = "unique name"
    product.valid?.must_equal true
    product.price = "clearly not a number"
    product.valid?.must_equal false
  end
  it "must have a price value greater than 0" do
    product.user_id = two.id
    product.price = 10
    product.name = "unique name"
    product.valid?.must_equal true
    product.price = -5
    product.valid?.must_equal false
  end
end
