class PostsController < ApplicationController
  before_action :authorize, except: [:index]

  def index
    @posts = Post.all
  end

  def new
  end

  def create
    post = Post.create(user_id: current_user.user_id, title: params[:title], content: params[:content])
    redirect_to "/posts/#{post.id}"
  end

  def show
    # Post 중에 하나를 선택해서 보는 거
    @post = Post.find(params[:id])
  end

  def edit
    # Post 중에 하나를 선택해서 Edit! Form 으로
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    post.update(user_id: current_user.user_id, title: params[:title], content: params[:content])
    redirect_to "/posts/#{post.id}"
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to "/"
  end
end
