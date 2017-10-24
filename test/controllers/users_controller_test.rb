require "test_helper"

describe UsersController do
  let(:user) { users(:one) }

  it "should get index" do
    get users_path
    must_respond_with :success
  end

  describe "show page" do

    describe "guest access" do
      it "should redirect if guest is not logged in" do
        get user_path(user.id)
        must_respond_with :redirect
      end
      it "should render a 404 if user show page does not exist" do
        get users_path(-100)
        must_respond_with render_404
      end
    end

    it "should redirect if logged in user tries to access someone else's show page" do
      login(user, :github)
      get user_path(users(:two).id)
      must_respond_with :redirect
    end

    it "should render 404 if user not found" do
      get user_path(-1)
      must_respond_with :not_found
    end
  end

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

    it "should not create a new user with bogus data" do
      proc {
        login(User.new(username: "", uid: '1234'), :github)
      }.wont_change "User.count"
      must_redirect_to root_path
    end

    it "redirects to root when it can't log in an existing user" do
      proc {
        login(User.new(username: "averi", uid: ''), :github)
      }.wont_change "User.count"
      must_redirect_to root_path
    end
  end

end
