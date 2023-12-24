class ArticlesController < ApplicationController
    before_action :set_article, only: [:show, :edit, :update, :destroy]
    def show
        @article = Article.find(params[:id])
        @comments = @article.comments
        @comment = Comment.new
    end

    def index
        @articles = Article.all
    end

    def new
        @article = Article.new
    end

    def edit
        @article = Article.find(params[:id])
    end

    def create
        @article = Article.new(article_params)
        @article.user = User.first
        if @article.save
        flash[:notice] = "Article was created successfully."
            redirect_to @article
        else
            render 'new', status: :unprocessable_entity
        end
    end

    def update
        if @article.update(article_params)
            flash[:notice] = "Article was updated successfully"
            redirect_to @article
        else
            render 'edit', status: :unprocessable_entity
        end
    end

    def destroy
        if @article.destroy
            flash[:notice] = "Article was deleted successfully"    
            redirect_to articles_path
        else
            render 'destroy', status: :unprocessable_entity
        end
    end

    private
    def set_article
    @article = Article.find(params[:id])
    end

    def article_params
        params.require(:article).permit(:title, :sub_title, :description)
    end

end