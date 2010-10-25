class SiteController < ApplicationController
  before_filter :redirect_to_dashboard, :only => :index
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
  end
  def tos
    @title = "LifeHelpr - Terms of Service"
  end
  def privacy
    @title = "LifeHelpr - Privacy Policy"
  end
  


end
