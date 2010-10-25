class UserSessionsController < ApplicationController
  def new
    @title = "LifeHelpr - Login"
    require_no_user
    @user_session = UserSession.new
    if request.xhr?
      @xhr = true
      render :template => false
    end
  end
  
  def create
    @title = "LifeHelpr - Login"
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Logged in, Welcome back #{@user_session.login}"
      redirect_to :action => 'index', :controller => 'users'
      return
    else
      flash[:error] = "There was an error processing your request.<br/>Please check your username/password and try again."
      redirect_to :action => 'new'
      return
    end
  end
  
  def destroy
    @title = "LifeHelpr - Logout"
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out"
    redirect_to :action => 'index', :controller => 'site'
  end
  
end
