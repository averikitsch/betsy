require "test_helper"

describe OrderProductsController do
  it "should get index" do
    get order_products_index_url
    value(response).must_be :success?
  end

  it "should get show" do
    get order_products_show_url
    value(response).must_be :success?
  end

  it "should get new" do
    get order_products_new_url
    value(response).must_be :success?
  end

  it "should get create" do
    get order_products_create_url
    value(response).must_be :success?
  end

  it "should get edit" do
    get order_products_edit_url
    value(response).must_be :success?
  end

  it "should get update" do
    get order_products_update_url
    value(response).must_be :success?
  end

  it "should get destroy" do
    get order_products_destroy_url
    value(response).must_be :success?
  end

end
