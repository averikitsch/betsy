class UsersController < ApplicationController
  def index
    @users = User.order(:username)
  end

  def show
    @user = User.find_by(id: params[:id].to_i)

    head :not_found unless @user
  end


  def toggle_active
    @product = Product.find_by(id: params[:id])
    # @product.active = params[:product][:active].to_i
    if @product.active
      @product.active = false
    else
      @product.active = true
    end

    if @product.save
      redirect_to user_path(@product.user)
    else
      flash[:status] = :failure
      flash[:result_text] = "Active status cannot be loaded"
    end
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
          flash[:result_text] = "Successfully added new user #{user.username}"
        else
          flash[:status] = :failure
          flash[:result_text] = "New user not saved"
        end
      else
        session[:user_id] = user.id
        flash[:status] = :success
        flash[:result_text] = "Successfully logged in as returning user #{user.username}"
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not authenticate user information"
    end
    redirect_to root_path
  end

  def logout
    if session[:user_id]
      session.delete(:user_id)
      flash[:status] = :success
      flash[:result_text] = "You are now logged out. Goodbye!"
    end
    redirect_to root_path
  end
end
