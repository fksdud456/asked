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

  def login

  end

  def loginprocess
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

  def logout
    session.clear
    flash[:notice] = "로그아웃되셨습니다"
    redirect_to '/'
  end

  def posts
    @user = User.find(params[:id])
    @posts = user.posts

  end

end
