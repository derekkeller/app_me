class SessionsController < ApplicationController

  def new
    @title = "Login"
  end

  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])

    if user
      sign_in user
      flash[:success] = "Logged in!"
      redirect_back_or user
    else
      flash.now[:failure] = "Invalid email/password combination."
      @title = "Login"
      render :new
    end 
  end

  def destroy
    sign_out
    flash[:success] = "Logged out!"
    redirect_to root_url
  end

end\
