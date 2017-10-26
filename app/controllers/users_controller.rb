class UsersController < ApplicationController
  def index
    @users = User.order(:username)
  end

  def show
    if @user.nil?
      if User.find_by(id: params[:id])
        flash[:status] = :failure
        flash[:result_text] = "Dear Paranormal Ally: We regret to inform you that accesss to this page is restricted."
        redirect_to users_path
      else
        # flash.now[:status] = :failure
        # flash.now[:result_text] = "Dear Paranormal Ally, this page doesn't exist"
        render_404
      end

    elsif session[:user_id].to_i != params[:id].to_i
      if User.find_by(id: params[:id])
        flash[:status] = :failure
        flash[:result_text] = "Dear Spooker: You cannot view another spooky's page!"
        redirect_to users_path
      else
        # flash.now[:status] = :failure
        # flash.now[:result_text] = "Dear Spooker, this page does not exist"
        render_404
      end
    else
      render_404 unless @user
    end
  end

  # def new
  # end
  #
  # def create
  # end

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
          flash[:result_text] = "Successfully added new ghoul, #{user.username}"
        else
          flash[:status] = :failure
          flash[:result_text] = "New ghoul could not be saved"
        end
      else
        session[:user_id] = user.id
        flash[:status] = :success
        flash[:result_text] = "Successfully summoned returning ghoul, #{user.username}"
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not authenticate your ghoul information"
    end
    redirect_to root_path
  end

  def logout
    if session[:user_id]
      session.delete(:user_id)
      flash[:status] = :success
      flash[:result_text] = "Your trip to the underworld has ended! Goodbye!"
    end
    redirect_to root_path
  end

  def order_fulfillment
    @user = User.find_by(id: params[:user_id].to_i)
    if @user.nil?
        flash[:status] = :failure
        flash[:result_text] = "Dear Paranormal Ally: We regret to inform you that accesss to this page is restricted."
        redirect_to users_path
    elsif session[:user_id].to_i != params[:user_id].to_i
        flash[:status] = :failure
        flash[:result_text] = "Dear Spooker: You cannot view another spooky's page! #{params}"
        redirect_to users_path
    else
      render_404 unless @user
    end
  end

end
