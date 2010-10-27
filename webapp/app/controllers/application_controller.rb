# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  helper_method :current_user, :format_time, :convert_to_12hour, :convert_to_24hour, :get_sms_carrier_list, :previous_or_default
  before_filter :set_user_time_zone, :store_previous_location

  def set_user_time_zone
    Time.zone = current_user.setting.time_zone if current_user
  end
  
  def get_sms_carrier_list
    carriers = {
      'AT&T' => 'txt.att.net',
      'Boost Mobile' => 'myboostmobile.com',
      'Cellular One' => 'mobile.celloneusa.com',
      'Cellular South' => 'csouth1.com',
      'Cingular GoPhone' => 'cingulartext.com',
      'Cricket' => 'sms.mycricket.com',
      'MetroPCS' => 'mymetropcs.com',
      'Nextel' => 'messaging.nextel.com',
      'Pioneer Cellular' => 'zsend.com',
      'Pocket Wireless' => 'sms.pocket.com',
      'Qwest Wireless' => 'qwestmp.com',
      'Sprint (PCS)' => 'messaging.sprintpcs.com',
      'Sprint (Nextel)' => 'page.nextel.com',
      'Straight Talk' => 'vtext.com',
      'T-Mobile' => 'tmomail.net',
      'US Cellular' => 'email.uscc.net',
      'Verizon' => 'vtext.com',
      'Virgin Mobile' => 'yrmobl.com'
    }
    return carriers
  end
  
  def convert_to_24hour(time_hash)
    hour = time_hash['hour'].to_i
    min = time_hash['min'].to_i
    suf = time_hash['suf']
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
  
  def convert_to_12hour(time_hash)
    hour = time_hash['hour'].to_i
    min = time_hash['min'].to_i
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
  end
  
  def format_time(time_hash)
    return "#{time_hash['hour']}:#{time_hash['min']} #{time_hash['suf']}"
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
  def current_user_id
    current_user.id
  end
  def admin?
    unless current_user.nil?
      return current_user.is_admin
    else
      return false
    end
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access that page"
      redirect_to login_path
      return false
    end
  end
  
  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access that page"
      redirect_to dashboard_path
      return false
    end
  end
  def store_location
    session[:return_to] = request.request_uri
  end
  def store_previous_location
    session[:previous] = request.referer
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  def previous_or_default(default)
    if session[:previous] == request.url
      return default
    else
      return session[:previous]
    end
    #session[:previous] = nil
  end
  
  def set_todo_name
    @todo = Todo.find(params[:id])
    unless @todo.user == current_user
      render :action => "noperms"
      return
    end
    if params[:value] == ''
      flash[:error] = "You must name the todo"
      render :inline=>"ERROR: Todo name cannot be blank"
      return
    end
    @todo.name = params[:value]
    @todo.save
    render :inline => @todo.name
  end
  
  def set_category_name
    @category = Category.find(params[:id])
    unless @category.user == current_user
      render :action => "noperms"
      return
    end
    if params[:value] == ''
      flash[:error] = "You must name the category"
      render :inline=>"ERROR: Category name cannot be blank"
      return
    end
    @category.name = params[:value]
    @category.save
    render :inline => @category.name
  end
  
end
