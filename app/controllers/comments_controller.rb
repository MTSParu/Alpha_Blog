class CommentsController < ApplicationController
    before_action :find_article
    before_action :require_user, only: [:create ]
    before_action :require_same_user, only: [:edit, :update, :destroy]
  
    def create
      @comment = @article.comments.new(comment_params)
      @comment.user = current_user
      if @comment.save
        redirect_to @article
      else
        render 'articles/show'
      end
    end

    def show
      @article = Article.find(params[:id])
      @comments = @article.comments
      @comment = Comment.new
    end
    
  
    def edit
      @comment = @article.comments.find(params[:id])
    end
  
    def update
      @comment = @article.comments.find(params[:id])
      if @comment.update(comment_params)
        redirect_to @article
      else
        render 'edit', status: :unprocessable_entity
      end
    end
  
    def destroy
      if @comment.destroy    
          redirect_back(fallback_location: article_path(@article))
      else
          render 'destroy', status: :unprocessable_entity
      end
    end
  
    private
  
    def find_article
      @article = Article.find(params[:article_id])
    end
  
    def comment_params
      params.require(:comment).permit(:body)
    end
  
  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def require_same_user
    @comment = Comment.find(params[:id])
    if current_user != @comment.user && !current_user.admin?
        flash[:alert] = "You can only edit or delete your own comment"
        redirect_to @article
    end
  end
  
end