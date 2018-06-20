class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
  end

  def create
    post = Post.create(username: params[:username], title: params[:title], content: params[:content])
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
    post.update(username: params[:username], title: params[:title], content: params[:content])
    redirect_to "/posts/#{post.id}"
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to "/"
  end
end
