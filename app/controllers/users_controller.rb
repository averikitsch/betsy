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
    @auth_hash = request.env['omniauth.auth']
    @user = User.find_by(uid: @auth_hash['uid'], provider: @auth_hash['provider'])

    if @user
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.username}"
    else
      @user = User.new(uid: @auth_hash['uid'], provider: @auth_hash['provider'], username: @auth_hash['info']['nickname'], email: @auth_hash['info']['email'])

      if @user.save
        session[:user_id] = @user.id
        flash[:success] = "Welcome, #{@user.username}"
      else
        flash[:error] = "Unable to save user"
      end
    end
    redirect_to root_path
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def login
    user
  end


end
