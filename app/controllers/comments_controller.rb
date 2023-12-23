class CommentsController < ApplicationController
    before_action :find_article
  
    def create
      @comment = @article.comments.new(comment_params)
      if @comment.save
        redirect_to @article
      else
        render 'articles/show'
      end
    end
  
    def edit
      @comment = @article.comments.find(params[:id])
    end
  
    def update
      @comment = @article.comments.find(params[:id])
      if @comment.update(comment_params)
        redirect_to @article
      else
        render 'edit'
      end
    end
  
    def destroy
      @comment = @article.comments.find(params[:id])
      @comment.destroy
      redirect_to @article
    end
  
    private
  
    def find_article
      @article = Article.find(params[:article_id])
    end
  
    def comment_params
      params.require(:comment).permit(:body)
    end
  end
  