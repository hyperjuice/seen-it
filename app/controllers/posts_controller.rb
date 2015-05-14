class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: :index

  # GET /posts
  # GET /posts.json
  
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

  # GET /posts/1
  # GET /posts/1.json
  def show
    authorize @post
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    authorize @post
  end

  # POST /posts
  # POST /posts.json
  def create

    # tag creation action
    tag_params = {category: params[:post][:tag]}
    tag = Tag.find_or_create_by(tag_params)

    # POST associated with logged in current_user
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

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update

    tag_params = {category: params[:post][:tag]}
    tag = Tag.find_or_create_by(tag_params)


    respond_to do |format|
    authorize @post
      if @post.update(post_params)
        @tag.update(tag_params)
        format.html { redirect_to @post, notice: 'Question was successfully updated' }
        format.json { render :show, status: :ok, location: @post }
      else
        @tag.update(tag_params)
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    authorize @post
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Question was successfully destroyed' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:name, :content)
    end

    def tag_params
      params.require(:tag).permit(:category)
    end

end
