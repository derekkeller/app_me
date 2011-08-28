class UsersController < ApplicationController

  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:destroy]

  def index
    @users = User.paginate(:page => params[:page])
    @title = "All Users"    
  end
  
  def new
    @user = User.new
    @title = "New User"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user, :flash => { :success => "User created!" }
    else
      render :new
    end    
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile udpated!"
      redirect_to @user
    else
      flash.now[:failure] = "Unable to update, please try again."
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, :flash => { :success => "#{@user.name} has been destroyed."}
  end
  
  private
    def authenticate
      deny_access unless signed_in?      
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, :flash => { :failure => "Sorry, you can't view that page."} ) unless current_user?(@user)
    end
    
    def admin_user
      user = User.find(params[:id])
      redirect_to(root_url) if (!current_user.admin? || current_user?(user))
    end
end