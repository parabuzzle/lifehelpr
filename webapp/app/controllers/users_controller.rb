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
    unless @user == current_user || admin?
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
    if @user.valid_password?(params[:user][:old_password])
      if params[:user][:password] == ''
        flash[:error]="Password field cannot be blank"
        render :action=>:edit
        return
      elsif params[:user][:password] != params[:user][:password_confirmation]
        flash[:error]="Your passwords do not match"
        render :action=>:edit
        return
      end
      @user.password=params[:user][:password]
      @user.password_confirmation=params[:user][:password_confirmation]
      if @user.save
        flash[:notice] = "You password has been updated"
        redirect_to :action=>:index
        return
      else
        flash[:error] = "Your passwords did not match"
        render :action=>:edit
      end
    else
      flash[:error] = "Your old password was not entered correctly. Please try again."
      render :action=>:edit
    end
  end
  
  def change_password
    @user = current_user
    @title = "LifeHelpr - Change Password"
    if request.post?
      if @user.valid_password?(params[:user][:old_password])
        @user.password=params[:user][:password]
        @user.password_confirmation=params[:user][:password_confirmation]
        if @user.save
          flash[:notice] = "You password has been updated"
          redirect_to :action=>:index
          return
        else
          flash[:error] = "Your passwords did not match"
        end
      else
        flash[:error] = "Your old password was not entered correctly. Please try again."
      end
    end
  end
  
end
