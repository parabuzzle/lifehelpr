class Setting < ActiveRecord::Base
  belongs_to :user
  #attr_accessor :default_reminder_schedule, :first_name, :last_name, :pager_email, :email_reminders, :page_reminders, :marketing_mail
  before_create :set_time_zone_default
  
  def set_time_zone_default
    self.time_zone = "Pacific Time (US & Canada)"
  end
  
  def pager_email_activation_code
  end
end
