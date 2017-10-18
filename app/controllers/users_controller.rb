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
end
