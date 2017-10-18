require "test_helper"

describe User do
  let(:user) { User.new }
  let(:one) { users(:one) }

  it "must be valid" do
    one.must_be :valid?
  end

  it "must have a username" do
    user.email = "email"
    user.username = "   "
    user.valid?.must_equal false

    user.username = "Name"
    user.valid?.must_equal true
  end


  it "must be unique" do
    one.username.must_equal "MyString"
    user.email = "email2"
    user.username = "MyString"
    user.valid?.must_equal false
  end

  it "must have an email" do
    user.username = "username"
    user.email = "    "
    user.valid?.must_equal false

    user.email = "email3"
    user.valid?.must_equal true
  end


  it "must be unique" do
    one.email.must_equal "MyString"
    user.username = "name2"
    user.username = "MyString"
    user.valid?.must_equal false
  end
end
