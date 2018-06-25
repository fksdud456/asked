class SessionsController < ApplicationController
  def new #login

  end

  def create  #loginprocess
    user = User.find_by(email: params[:email])
    # 1. 이메일이 가입되었는지 확인
    if user
      # 비밀번호 확인
      if user.authenticate(params[:password])
        # 일치하면 로그인, id를 session에 저장
         session[:user_id] = user.id
         flash[:notice] = "#{user.username}님 로그인되셨습니다."
         redirect_to '/'
       else
         flash[:alert] = "비밀번호가 다릅니다."
         redirect_to :back
       end
    else
      # 회원가입 페이지로!
      flash[:alert] = "가입되지 않은 이메일입니다."
      redirect_to '/signup'
    end
  end

  def destroy #logout
    session.clear
    flash[:notice] = "로그아웃되셨습니다"
    redirect_to '/'
  end
end
