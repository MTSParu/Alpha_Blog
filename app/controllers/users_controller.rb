class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :require_user, only: [:edit, :update]
    before_action :require_same_user, only: [:edit, :update, :destroy]


    def acceptable_image
        return unless profile_image.attached?
        
        unless profile_image.blob.byte_size <= 1.megabyte
            errors.add(:profile_image, "is too big")
        end

        acceptable_types = ["image/jpeg", "image/png"]
        unless acceptable_types.include?(profile_image.content_type)
            errors.add(:profile_image, "must be a JPEG or PNG")
        end
    end

    def profile_image
        if profile_image_attachment.present? && profile_image_attachment.attached?
            profile_image_attachment.service_url
        end
    end

    def show
        @user = User.find(params[:id])
        @articles = @user.articles.paginate(page: params[:page], per_page:2)
    end

    def index
        @users = User.paginate(page: params[:page], per_page:2)
    end

    def new
        @user = User.new
    end

    def edit
    end

    def update
        if @user.update!(user_params)
            flash[:notice] = "Your account information was successfully updated"
            redirect_to @user
        else
            render 'edit'
        end
    end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            flash[:notice] = "Welcometo the Alpha Blog #{@user.username}, You have successfully signed up"
            redirect_to articles_path
        else
            render 'new', status: :unprocessable_entity
        end
    end

    def destroy
        @user.destroy
        session[:user_id] = nil if @user == current_user
        flash[:notice] = "Account and all associated articlessuccessfully deleted"
        redirect_to articles_path
    end

    private
    def user_params
        params.require(:user).permit(:profile_image, :username, :email, :password)
    end

    def set_user
        @user = User.find(params[:id])
    end

    def require_same_user
        if current_user != @user && !current_user.admin?
            flash[:alert] = "You can only edit or delete your own account"
            redirect_to @user
        end
    end

end
