class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # VIEW 에서 편하게 method 호출을 하려고
  helper_method :current_user

  def current_user
    # session에 user정보가 있는 경우,
    # @user에 User를 찾아서 저장한다.
    # '||' , @user가 비어있는 경우에만 User를 찾아서 저장하도록 하기위해서
    @user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authorize
    if current_user.nil?
      flash[:alert] = "로그인을 해주세요."
      redirect_to '/'
    end
  end
  
end
