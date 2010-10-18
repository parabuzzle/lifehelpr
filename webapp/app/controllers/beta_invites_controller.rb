class BetaInvitesController < ApplicationController
  before_filter :require_user
  
  def index
    @title = "LifeHelpr - Your Beta Invites"
    @user = current_user
    @invites = @user.beta_invites
  end
  
  def new
    @title = "LifeHelpr - Invite Someone"
    @user = current_user
    @invite = @user.beta_invites.new
  end
  
  def create
    @title = "LifeHelpr - Invite Someone"
    @user = current_user
    @invite = @user.beta_invites.new
    @invite.email_address = params[:beta_invite][:email_address]
    unless BetaInvite.find_by_email_address(params[:beta_invite][:email_address]).nil?
      flash[:error] = "That email address has already been invited to use LifeHelpr"
      render :action=>:new
      @invite = nil
    else
      if @invite.save
        Emails.deliver_beta_invite(@invite, params[:beta_invite][:from_name], params[:beta_invite][:friend_name])
        flash[:notice] = "Invite Sent"
        redirect_to :action => "index"
      else
        flash[:error] = "There was an error processing your request at this time. Please try again later. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
        render :action => 'new'
      end
    end
  end
  
end
