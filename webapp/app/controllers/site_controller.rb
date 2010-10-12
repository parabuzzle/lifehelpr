class SiteController < ApplicationController
  before_filter :redirect_to_dashboard
  
  def redirect_to_dashboard
    if current_user
      redirect_to :controller => :users, :action => :index
    end
  end
  
  def index
    @title = "LifeHelpr - Your personal concierge"
  end
end
