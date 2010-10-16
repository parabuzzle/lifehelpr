class DefaultReminderSchedulesController < ApplicationController
  before_filter :require_user
  def create
    @user = current_user
    @def_rem = @user.default_reminder_schedules.new
    hash = params[:time]
    time = convert_to_24hour({'hour'=>hash['hour'], 'min'=>hash['min'], 'suf'=>hash['suf']})
    @def_rem.hour = time['hour']
    @def_rem.min = time['min']
    @def_rem.time_zone = @user.setting.time_zone
    @def_rem.pager = params[:reminder][:pager]
    @def_rem.email = params[:reminder][:email]
    if @def_rem.save
      flash[:notice] = "Reminder time added"
      redirect_to :controller => :settings, :action => :edit
    else
      flash[:error] = "There was an error processing your request at this time. Please try again later. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
      redirect_to :controller => :settings, :action => :edit
    end
  end
  
  def delete
    if request.post?
      @def_rem = DefaultReminderSchedule.find(params[:id])
      unless @def_rem.user == current_user || admin?
        render :action => "noperms"
        return
      end
      if @def_rem.destroy
        flash[:notice] = "Reminder removed"
        redirect_to :controller => :settings, :action => :edit
        return
      else
        flash[:error] = "There was an error processing your request at this time. Please try again later. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
        redirect_to :controller => :settings, :action => :edit
        return
      end
    else
      redirect_to :controller => :settings, :action => :index
    end
  end
  
  def edit
    @user = current_user
    @settings = @user.setting
    @def_rem = DefaultReminderSchedule.find(params[:id])
    unless @def_rem.user == current_user || admin?
      render :action => "noperms"
      return
    end
    time = convert_to_12hour({'hour'=>@def_rem.hour, 'min'=>@def_rem.min})
    @hour = time['hour']
    @min = time['min']
    @suf = time['suf']
    @title = "LifeHelpr - Edit reminder time"
  end
  
  def update
    @title = "LifeHelpr - Edit reminder time"
    @user = current_user
    @def_rem = DefaultReminderSchedule.find(params[:id])
    unless @def_rem.user == current_user || admin?
      render :action => "noperms"
      return
    end
    hash = params[:time]
    time = convert_to_24hour({'hour'=>hash['hour'], 'min'=>hash['min'], 'suf'=>hash['suf']})
    @def_rem.hour = time['hour']
    @def_rem.min = time['min']
    @def_rem.pager = params[:default_reminder_schedule][:pager]
    @def_rem.email = params[:default_reminder_schedule][:email]
    if @def_rem.update_attributes(params[:def_rem])
      flash[:notice] = "Successfully updated your reminder"
      redirect_to :action => "edit", :controller => :settings
    else
      flash[:error] = "There was an error processing your request at this time. Please try again later. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
      render :action => 'edit'
    end
  end
end
