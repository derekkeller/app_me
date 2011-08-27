class UsersController < ApplicationController
  
  def new
    @user = User.new
    @title = "New User"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "User created!"
      redirect_to @user
    else
      render :new
    end    
  end

  def show
    @user = User.find(params[:id])
  end

end