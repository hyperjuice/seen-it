class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: :index
  
  def score
    self.get_upvotes.size - self.get_downvotes.size
  end

  def upvote
    @post = Post.find(params[:id])
    @post.liked_by current_user
    redirect_to @post
  end
  
  def downvote
    @post = Post.find(params[:id])
    @post.downvote_from current_user
    redirect_to @post
  end

  def index
    posts = Post.all.sort_by do |post|
      post.get_upvotes.size
    end
    @posts = posts.reverse
  end

  def show
    authorize @post
  end

  def new
    @post = Post.new
  end

  def edit
    authorize @post
  end

  def create
    tag_params = {category: params[:post][:tag]}
    tag = Tag.find_or_create_by(tag_params)
    @post = current_user.posts.build(post_params)
    respond_to do |format|
      if @post.save
        @post.tags << tag
        format.html { redirect_to @post, notice: 'Question was successfully created' }
        format.json { render :show, status: :created, location: @post }
      else
        @post.tags << tag
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    tag_params = {category: params[:post][:tag]}
    tag = Tag.find_or_create_by(tag_params)
    respond_to do |format|
    authorize @post
      if @post.update(post_params)
        @post.tags << tag
        format.html { redirect_to @post, notice: 'Question was successfully updated' }
        format.json { render :show, status: :ok, location: @post }
      else
        @post.tags << tag
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @post
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Question was successfully destroyed' }
      format.json { head :no_content }
    end
  end

private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:name, :content)
  end

  def tag_params
    params.require(:tag).permit(:category)
  end
end
