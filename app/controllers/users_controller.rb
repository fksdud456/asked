class UsersController < ApplicationController
  def index
  end

  def new
  end

  def create
    # email 검증
    if User.find_by(email: params[:email])
      flash[:alert] = "이미 가입된 이메일입니다."
      redirect_to :back
    else
      # 비밀번호 확인
      if params[:password] != params[:password_confirm]
        flash[:alert] = "비밀번호가 일치하지 않습니다."
        redirect_to :back
      else
        user = User.create(username: params[:username], email: params[:email], password: params[:password])
        flash[:notice] = "#{user.username}님 가입이 완료되었습니다."
        redirect_to '/'
      end
    end
  end
end
