class UsersController < ApplicationController
  
  before_filter :require_user, :except => [:new, :create, :forgot_password, :reset_password]
  before_filter :require_no_user, :only => [:new, :create, :forgot_password]
  
  def index
    @title = "LifeHelpr - Dashboard"
    @user = current_user
    @top5_todos = @user.todos.top5
    @todos_undone = @user.todos.undone
    @todos_closed_this_week = @user.todos.last_week_closed
    @todos_created_this_week = @user.todos.last_week_created
    @todos_late = @user.todos.due_now
    @lists = @user.lists
    @categories = @user.categories
    @uncat_undone_count = @user.todos.find(:all, :conditions => {:status => false, :archived=>false, :deleted => false, :category_id=>nil}).count
    @uncat_archive_count = @user.todos.find(:all, :conditions => { :archived=>true, :deleted => false, :category_id=>nil}).count
  end
  
  def new
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
      @user.beta_token = params[:user][:beta_token]
      if @user.save
        flash[:notice] = "Registration Successful"
        Emails.deliver_welcome(@user)
        redirect_to root_url
        return
      else
        logger.error @user.errors.inspect
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
    @title = "LifeHelpr - Edit Account"
    @user = current_user
    unless @user == current_user || admin?
      render :action => "noperms"
      return
    end
  end
  
  def update
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
  
  def forgot_password
    @title = "LifeHelpr - Forgot Password"
    if request.post?
      flash[:notice] = nil
      flash[:error] = nil
      user = params[:user]
      u = User.find_by_login_and_email(user[:login], user[:email])
      unless u.nil?
        if Emails.deliver_forgot_password(u)
          flash[:notice] = "Your password has been reset please check your email for further instructions"
          redirect_to :controller => 'site', :action=>'index'
          return
        else
          flash[:error] = "There was an error processing your request at this time. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>. "
        end
      else
        flash[:error] = "Your username and email don't match any users. Please check and try again."
        render :action=>:forgot_password
        return
      end
    end
  end
  
  def reset_password
    @title="LifeHelpr - Reset Password"
    if params[:user].nil?
      @user = User.find_by_perishable_token(params[:token])
    else
      @user = User.find_by_perishable_token(params[:user][:token])
    end
    if request.post?
      user = params[:user]
      @user.password = user[:password]
      @user.password_confirmation = user[:password_confirmation]
      if @user.save
        flash[:notice] = "Password successfully saved"
        redirect_to :action=>:index
        return
      else
        flash[:error] = "There was an error saving your password. Please try again."
        redirect_to :action=>:reset_password, :token => params[:user][:token]
        return
      end
    end
  end
  
end
