class SiteController < ApplicationController
  before_filter :redirect_to_dashboard, :only => :index
  
  def redirect_to_dashboard
    if current_user
      redirect_to :controller => :users, :action => :index
    end
  end
  
  def index
    @title = "LifeHelpr - Your personal concierge"
  end
  def about
    @title = "LifeHelpr - What we do"
  end


end
