class SettingsController < ApplicationController
  def edit
    require_user
    @title = "LifeHelpr - Edit Settings"
    @user = current_user
    @settings = @user.setting
    unless @settings.user == current_user || admin?
      render :action => "noperms"
      return
    end
    @def_rem = @user.default_reminder_schedules
    if !@settings.pager_email.nil?
      if @settings.pager_email != ""
        unless @settings.pager_email_active?
          @display_code = true
          notice = flash[:notice]
          if notice.nil? then notice = "" end
          unless notice.match(/Resent/)
            flash[:notice] = "Your pager email hasn't been activated yet. Please enter your activation code to start using your pager reminders."
          end
        end
      end
    end
  end
  
  def resend_pager_activation
    @settings = current_user.setting
    unless @settings.pager_email == '' || @settings.pager_email.nil?
      Emails.deliver_pager_activation(@settings.pager_email, @settings.pager_email_token)
      flash[:notice] = "Resent pager activation code"
    else
      flash[:error] = "There is no pager email address set"
    end
    redirect_to :action=>:edit
  end
  
  def update
    require_user
    @title = "LifeHelpr - Edit Settings"
    @user = current_user
    @settings = @user.setting
    unless @settings.user == current_user || admin?
      render :action => "noperms"
      return
    end
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
    @user.update_attributes(params[:user])
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
      flash[:error] = "There was an error processing your request at this time. Please try again later. If you are expierencing this issue for more than 24 hours please send an email with a short description of the problem to <a href='mailto:help@lifehelpr.com'>help@lifehelpr.com</a>."
      render :action => 'edit'
    end
  end
end
