class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_404
      render file: "/public/404.html", status: 404
    # raise ActionController::RoutingError.new('Not Found')
  end

  before_action :find_user

  private
  def find_user
    if session[:user_id]
      @user = User.find_by(id: session[:user_id])
    end
  end
end
