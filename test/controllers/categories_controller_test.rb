require "test_helper"

describe CategoriesController do
  let(:one) { categories(:one)}
  let(:user) { users(:one) }

  describe "categories view routes" do
    it "should get index" do
      get categories_path
      must_respond_with :success
    end
  end

  describe "categories add new" do

    it "should not let a guest get new" do
      get new_category_path
      must_respond_with :bad_request
    end

    it "doesn't let a guest add a new category" do
      proc { post categories_path, params: {category: {name: "Spooks"}}}.must_change 'Category.count', 0
      must_respond_with :redirect
    end

    it "should let a user get new" do
      login(user, :github)
      get new_category_path
      must_respond_with :success
    end

    it "a user can add a new category" do
      login(user, :github)
      proc { post categories_path, params: {category: {name: "Spooks"}}}.must_change 'Category.count', 1
      must_respond_with :redirect
    end

    it "must be a unique category" do
      login(users(:one),:github)
      one.name.must_equal "potions"
      proc { post categories_path, params: {category: {name: "potions"}}}.must_change 'Category.count', 0
    end

    it "name not be blank" do
      login(users(:one),:github)
      proc { post categories_path, params: {category: {name: "   "}}}.must_change 'Category.count', 0

      post categories_path, params: {category: {name: ""}}
      must_respond_with :bad_request
    end
  end

end
