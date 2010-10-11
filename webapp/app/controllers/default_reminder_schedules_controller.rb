class DefaultReminderSchedulesController < ApplicationController
  before_filter :require_user
  def create
    @user = current_user
    @def_rem = @user.default_reminder_schedules.new
    time = get_time_hash(params[:time][:hour],params[:time][:min],params[:time][:suf])
    @def_rem.hour = time['hour']
    @def_rem.min = time['min']
    @def_rem.pager = params[:reminder][:pager]
    @def_rem.email = params[:reminder][:email]
    if @def_rem.save
      flash[:notice] = "Reminder time added"
      redirect_to :controller => :settings, :action => :edit
    else
      flash[:error] = "There was an error processing your request"
      redirect_to :controller => :settings, :action => :edit
    end
  end
  
  def delete
    if request.post?
      @def_rem = DefaultReminderSchedule.find(params[:id])
      if @def_rem.destroy
        flash[:notice] = "Reminder removed"
        redirect_to :controller => :settings, :action => :edit
        return
      else
        flash[:error] = "There was an error processing your request"
        redirect_to :controller => :settings, :action => :edit
        return
      end
    else
      redirect_to :controller => :settings, :action => :index
    end
  end
  
  def edit
    @user = current_user
    @def_rem = DefaultReminderSchedule.find(params[:id])
    time = get_12_hour_hash(@def_rem.hour, @def_rem.min)
    local = get_24_hour_hash_local(time["hour"],time["min"], time["suf"],@user.setting.time_zone)
    local_time = get_12_hour_hash(local["hour"], local["min"])
    @hour = local_time["hour"]
    @min = local_time["min"]
    @suf = local_time["suf"]
    @title = "LifeHelpr - Edit reminder time"
  end
  
  def update
    @title = "LifeHelpr - Edit reminder time"
    @user = current_user
    @def_rem = DefaultReminderSchedule.find(params[:id])
    time = get_24_hour_hash_utc(params[:time][:hour],params[:time][:min],params[:time][:suf],@user.setting.time_zone)
    @def_rem.hour = time['hour']
    @def_rem.min = time['min']
    @def_rem.pager = params[:default_reminder_schedule][:pager]
    @def_rem.email = params[:default_reminder_schedule][:email]
    if @def_rem.update_attributes(params[:def_rem])
      flash[:notice] = "Successfully updated reminder"
      redirect_to :action => "edit", :controller => :settings
    else
      render :action => 'edit'
    end
  end
end
