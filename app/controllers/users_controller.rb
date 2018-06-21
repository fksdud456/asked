class UsersController < ApplicationController
  def index
  end

  def new
  end

  def create
    unless User.find_by(email: params[:email])
      @user = User.new(username: params[:username],
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirm])
        if @user.save
          # 가입이 되면, true + 저장
          flash[:notice] = "가입을 축하드립니다."
          redirect_to '/'
        else
          # 비밀번호가 달라서 가입이 실패하면, false + 저장이 안됨
          flash[:alert] = "비밀번호가 다릅니다."
          redirect_to :back
        end
      else
        flash[:alert] = "이미 등록된 이메일 입니다."
        redirect_to :back
      end


    # # email 검증
    # if User.find_by(email: params[:email])
    #   flash[:alert] = "이미 가입된 이메일입니다."
    #   redirect_to :back
    # else
    #   # 비밀번호 확인
    #   if params[:password] != params[:password_confirm]
    #     flash[:alert] = "비밀번호가 일치하지 않습니다."
    #     redirect_to :back
    #   else
    #     user = User.create(username: params[:username], email: params[:email], password: params[:password])
    #     flash[:notice] = "#{user.username}님 가입이 완료되었습니다."
    #     redirect_to '/'
    #   end
    # end
  end
end
