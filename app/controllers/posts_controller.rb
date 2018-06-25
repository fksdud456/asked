class PostsController < ApplicationController
  before_action :authorize, except: [:index]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all
  end

  def new
  end

  def create
    # post = Post.create(post_params)
    @post = current_user.posts.new(post_params)
    @post.save
    flash[:notice] = "글 작성이 완료되었습니다."
    redirect_to "/posts/#{post.id}"
  end

  def show
    # Post 중에 하나를 선택해서 보는 거
    # @post = Post.find(params[:id])
  end

  def edit
    # Post 중에 하나를 선택해서 Edit! Form 으로
    # @post = Post.find(params[:id])
  end

  def update
    # post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to "/posts/#{post.id}"
  end

  def destroy
    # post = Post.find(params[:id])
    @post.destroy
    redirect_to "/"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.permit(:title, :content).merge(user_id: current_user.id)
  end

end
