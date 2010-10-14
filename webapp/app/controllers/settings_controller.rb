class SettingsController < ApplicationController
  def edit
    require_user
    @title = "LifeHelpr - Edit Settings"
    @user = current_user
    @settings = @user.setting
    @def_rem = @user.default_reminder_schedules
    if !@settings.pager_email.nil?
      if @settings.pager_email != ""
        unless @settings.pager_email_active?
          @display_code = true
          flash[:notice] = "Your pager email hasn't been activated yet. Please enter your activation code to start using your pager reminders."
        end
      end
    end
  end
  
  def update
    require_user
    @title = "LifeHelpr - Edit Settings"
    @user = current_user
    @settings = @user.setting
    tz = @settings.time_zone
    if @settings.pager_email_token == params[:setting][:pager_email_activation_code]
      @settings.pager_email_active = true
    end
    if @settings.pager_email != params[:setting][:pager_email]
      @settings.pager_email_active = false
      @settings.pager_email_token = rand(10000).to_s[0,5].to_i
      unless params[:setting][:pager_email] == ''
        Emails.deliver_pager_activation(params[:setting][:pager_email], @settings.pager_email_token)
      end
    end
    params[:setting].delete(:pager_email_activation_code)
    if @settings.update_attributes(params[:setting])
      if tz != params[:setting][:time_zone]
        @user.default_reminder_schedules.each do |r|
          r.time_zone = params[:setting][:time_zone]
          r.save
        end
      end
      flash[:notice] = "Successfully updated user settings"
      redirect_to settings_path
    else
      render :action => 'edit'
    end
  end
end
