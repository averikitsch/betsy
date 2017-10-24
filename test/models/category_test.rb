require 'test_helper'

describe Category do
  let(:category) { Category.new }
  describe "validations" do
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

    it "doesn't create a new category with different capitalization" do
      proc {Category.new(name: "PoTions")}.must_change 'Category.count', 0
    end
  end
  describe "relations " do
    it "has relations to product" do
      prd = products(:one)
      cat = Category.first
      cat.must_respond_to :products
      cat.products << prd
      cat.products[0].must_equal products(:one)
    end

  end
end
