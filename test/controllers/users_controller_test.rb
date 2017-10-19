require "test_helper"

describe UsersController do
  it "should get index" do
    get users_path
    value(response).must_be :success?
  end

  it "should get show" do
    get user_path(users(:two))
    value(response).must_be :success?
  end

  it "logs in an existing user" do
    start_count = User.count
    user = users(:one)

    login(user, "github")
    must_redirect_to root_path
    session[:user_id].must_equal user.id
    User.count.must_equal start_count
  end

  it "creates a new user" do
    start_count = User.count
    user = User.new(provider: "github", uid: 99, username: "dot", email: "dot@user.com")

    login(user, "github")

    must_redirect_to root_path
    User.count.must_equal start_count + 1
    session[:user_id].must_equal User.last.id
  end

  it "should get destroy" do
    get user_path(users(:one))
    value(response).must_be :success?
  end

end
