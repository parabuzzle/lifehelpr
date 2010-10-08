class UserSessionsController < ApplicationController
  def new
    @title = "LifeHelpr - Login"
    require_no_user
    @user_session = UserSession.new
    if params[:facebox]
      render :template => false
    end
  end
  
  def create
    @title = "LifeHelpr - Login"
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Logged in"
      redirect_to :action => 'index', :controller => 'users'
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @title = "LifeHelpr - Logout"
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Logged out"
    redirect_to :action => 'index', :controller => 'site'
  end
end
