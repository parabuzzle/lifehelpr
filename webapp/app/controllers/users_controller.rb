class UsersController < ApplicationController
  
  def new
    @title = "LifeHelpr - Register"
    @user = User.new
  end
  
  def create
    @title = "LifeHelpr - Register"
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Registration Successful"
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @title = "LifeHelpr - Edit Account"
    @user = current_user
  end
  
  def update
    @title = "LifeHelpr - Edit Accout"
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user info"
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
  
end
