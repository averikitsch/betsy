require 'test_helper'

describe Category do
  let(:category) { Category.new }

  it "category without name is invalid" do
    category.valid?.must_equal false
    category.name = ''
    category.valid?.must_equal false
  end

  it "category with name is valid" do
    category.name = 'decorations'
    category.valid?.must_equal true
  end

  it "must be unique" do
    category.name = 'decorations'
    category.save
    new_category = Category.new(name: 'decorations')
    new_category.valid?.must_equal false
  end

  it "has relations to product" do
    prd = products(:one)
    cat = Category.first
    cat.products << prd
    cat.products[0].must_equal products(:one)
  end
end
