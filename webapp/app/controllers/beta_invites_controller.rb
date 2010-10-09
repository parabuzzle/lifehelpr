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
    @invite = @user.beta_invites.new(params[:beta_invite])
    if @invite.save
      flash[:notice] = "Invite Sent"
      redirect_to :action => "index"
    else
      render :action => 'new'
    end
  end
  
end
