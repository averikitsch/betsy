require "test_helper"

describe UsersController do
  let(:user) { users(:one) }
  # it "should get index" do
  #   get users_path
  #   value(response).must_be :success?
  # end
  #
  # it "should get show" do
  #   get user_path(users(:two))
  #   value(response).must_be :success?
  # end

  describe "auth_callback" do
    it "should not create a new user on repeat logins" do
      proc {
        login(user, :github)
      }.wont_change "User.count"
      must_redirect_to root_path
    end

    it "should update the session with user ID" do
      login(user, :github)
      session[:user_id].must_equal user.id
      must_redirect_to root_path
    end

    it "should create a new user on first login" do
      start_count = User.count
      new_user = User.new(provider: "github", uid: 99, username: "dot", email: "dot@user.com")

      login(new_user, :github)

      must_redirect_to root_path
      User.count.must_equal start_count + 1
      session[:user_id].must_equal User.last.id
    end

    it "should logout a user" do
      login(user, :github)
      session[:user_id].must_equal user.id
      delete logout_path
      session[:user_id].must_equal nil
      must_redirect_to root_path
    end
  end



end
