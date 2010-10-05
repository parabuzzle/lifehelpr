class SettingsController < ApplicationController
  def edit
    require_user
    @title = "LifeHelpr - Edit Settings"
    @user = current_user
    @settings = @user.setting
  end
  
  def update
    #attr_accessor :default_reminder_schedule, :first_name, :last_name, :pager_email, :email_reminders, :page_reminders, :marketing_mail
    require_user
    @title = "LifeHelpr - Edit Settings"
    @user = current_user
    @settings = @user.setting
    if @settings.update_attributes(params[:setting])
      flash[:notice] = "Successfully updated user settings"
      redirect_to settings_path
    else
      render :action => 'edit'
    end
  end
end
