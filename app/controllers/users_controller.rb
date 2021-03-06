class UsersController < ApplicationController
  before_action :signed_in_user, 
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def show
  	@user = User.find(params[:id]) 
  	#find can smartly turn params[:id] from a str to int
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params) #not final
  	if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Gif Post n' Share App!"
      redirect_to @user
  	else
  		render 'new'
    end
  end

  def edit
    # @user = User.find(params[:id])
    # made obselete by the correct_user attribute above

  end

  def update
    # @user = User.find(params[:id])
    # see edit above
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
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
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before Filters

    

    def signed_in_user
      unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
      end 
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?        
    end

end
