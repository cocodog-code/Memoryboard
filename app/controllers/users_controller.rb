class UsersController < ApplicationController
  # before_action :require_logged_in, only: [:edit, :update, :index, :destroy,
                                            # :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,   only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @comment = Comment.new
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to Memoryboard!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    #プロフィール画面から自身のアカウントを削除する場合
    if request.referrer == edit_user_url
      if current_user?(@user)
        @user.destroy
        flash[:success] = "Account deleted"
        redirect_to root_url
      else
        redirect_to root_url
      end
    #adminユーザーが他のユーザーのアカウントを削除する場合
    else
      @user.destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    end
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
    
  private
  
    def user_params
      params.require(:user).permit(:full_name, :user_name, :email,
                                   :website, :introduction, :phone_number,
                                   :gender, :password,:password_confirmation)
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
