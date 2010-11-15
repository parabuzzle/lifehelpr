class SiteController < ApplicationController
  before_filter :redirect_to_dashboard, :only => :index
  before_filter :store_location
  def redirect_to_dashboard
    if current_user
      redirect_to :controller => :users, :action => :index
    end
  end
  
  def index
    @title = "LifeHelpr - We make your life easier"
    render :layout => "splash"
  end
  def about
    @title = "LifeHelpr - What we do"
    render :layout => "splash"
  end
  def tos
    @title = "LifeHelpr - Terms of Service"
    render :layout => "splash"
  end
  def privacy
    @title = "LifeHelpr - Privacy Policy"
    render :layout => "splash"
  end
  def help
    @title = "LifeHelpr - Help"
    render :layout => "splash"
  end
  


end
