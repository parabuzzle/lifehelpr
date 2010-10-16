class UsersController < ApplicationController
  
  def index
    @title = "LifeHelpr - Dashboard"
    require_user
    @user = current_user
    @top5_todos = @user.todos.top5
    @todos_undone = @user.todos.undone
    @todos_closed_this_week = @user.todos.last_week_closed
    @todos_created_this_week = @user.todos.last_week_created
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
    @user = User.new
    @beta = BetaInvite.find_by_beta_token(params[:user][:beta_token])
    if @beta and @beta.email_address == params[:user][:email]
      @user = User.new(params[:user])
      if @user.save
        flash[:notice] = "Registration Successful"
        redirect_to root_url
        return
      else
        flash[:error] = "There was an error processing your request at this time. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
        render :action => 'new'
        return
      end
    else
      flash[:error] = "Your beta code and email address don't match please check them and try again."
      redirect_to :action => :new, :email => params[:user][:email], :beta_token => params[:user][:beta_token]
      return
    end
  end
  
  def edit
    require_user
    @title = "LifeHelpr - Edit Account"
    @user = current_user
    @settings = @user.setting
    unless @settings.user == current_user || admin?
      render :action => "noperms"
      return
    end
  end
  
  def update
    require_user
    @title = "LifeHelpr - Edit Accout"
    @user = current_user
    @settings = @user.setting
    unless @settings.user == current_user || admin?
      render :action => "noperms"
      return
    end
    if @settings.update_attributes(params[:settings])
      flash[:notice] = "Successfully updated user settings"
      redirect_to root_url
    else
      flash[:error] = "There was an error processing your request at this time. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
      render :action => 'edit'
    end
  end
  
end
