require "test_helper"

describe CategoriesController do
  let(:one) { categories(:one)}

  describe "categories view routes" do
    it "should get index" do
      get categories_path
      must_respond_with :success
    end

    it "should get new" do
      get new_category_path
      must_respond_with :success
    end
  end

  describe "categories add new" do
    it "a merchant can add a new category" do
      proc { post categories_path, params: {category: {name: "Spooks"}}}.must_change 'Category.count', 1
      must_respond_with :redirect
    end

    it "must be a unique category" do
      one.name.must_equal "potions"
      proc { post categories_path, params: {category: {name: "potions"}}}.must_change 'Category.count', 0
    end
  end

end
