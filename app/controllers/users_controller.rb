class UsersController < ApplicationController
  def index
    @users = User.order(:username)
  end

  def show
    @user = User.find_by(id: params[:id].to_i)

    head :not_found unless @user
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def login
    auth_hash = request.env['omniauth.auth']

    if auth_hash['uid']
      user = User.find_by(provider: params[:provider], uid: auth_hash['uid'])
      if user.nil?
        user = User.from_auth_hash(params[:provider], auth_hash)
        if user.save
          session[:user_id] = user.id
          flash[:status] = :success
          flash[:message] = "Successfully added new user #{user.username}"
        else
          flash[:status] = :failure
          flash[:message] = "New user not saved"
        end
      else
        session[:user_id] = user.id
        flash[:status] = :success
        flash[:message] = "Successfully logged in as returning user #{user.username}"
      end
    else
      flash[:status] = :failure
      flash[:message] = "Could not authenticate user information"
    end
    redirect_to root_path
  end

  def logout
    if session[:user_id]
      session.delete(:user_id)
      flash[:success] = "You are now logged out. Goodbye!"
    end
    redirect_to root_path
  end
end
