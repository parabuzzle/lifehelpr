# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  helper_method :current_user, :make_time, :get_12_hour_hash
  before_filter :set_user_time_zone

  def set_user_time_zone
    Time.zone = current_user.setting.time_zone if current_user
  end
  
  def make_time(hour, min)
    hour = hour.to_i
    if hour < 12
      suf = "A.M."
    else
      suf = "P.M."
    end
    if min == 0
      min = "00"
    end
    if hour == 0
      hour = 12
    elsif hour == 24
      hour = 12
    else
      hour = hour%12
    end
    if hour == 0
      hour = 12
    end
    time = "#{hour}:#{min} #{suf}"
    return time
  end
  
  def get_12_hour_hash(hour=1, min=0)
    hour = hour.to_i
    min = min.to_i
    if hour < 12
      suf = "A.M."
    else
      suf = "P.M."
    end
    if min == 0
      min = "00"
    end
    if hour == 0
      hour = 12
    elsif hour == 24
      hour = 12
    else
      hour = hour%12
    end
    if hour == 0
      hour = 12
    end
    time = {'hour'=>hour, 'min'=>min, 'suf'=>suf}
    return time
  end
  
  def get_time_hash(hour,min,suf)
    hour = hour.to_i
    min = min.to_i
    if suf == "P.M."
      hour = hour+12
    elsif hour == 12
      hour = 0
    end
    if hour == 24
      hour = 12
    end
    time = {'hour' => hour, 'min' => min}
    return time
  end
    
  #User session and user stuff
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_path
      return false
    end
  end
  
  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to users_path
      return false
    end
  end
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def set_todo_name
    @todo = Todo.find(params[:id])
    @todo.name = params[:value]
    @todo.save
    render :inline => @todo.name
  end
  
end
