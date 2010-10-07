class UsersController < ApplicationController
  
  def index
    @title = "LifeHelpr - Dashboard"
    require_user
  end
  
  def new
    require_no_user
    @title = "LifeHelpr - Register"
    @user = User.new
    if params[:facebox]
      render :layout=>false
    end
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
    require_user
    @title = "LifeHelpr - Edit Account"
    @user = current_user
    @settings = @user.setting
  end
  
  def update
    require_user
    @title = "LifeHelpr - Edit Accout"
    @user = current_user
    @settings = @user.setting
    if @settings.update_attributes(params[:settings])
      flash[:notice] = "Successfully updated user settings"
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
  
end
