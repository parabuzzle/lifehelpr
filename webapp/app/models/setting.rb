class Setting < ActiveRecord::Base
  belongs_to :user
  #attr_accessor :default_reminder_schedule, :first_name, :last_name, :pager_email, :email_reminders, :page_reminders, :marketing_mail
end
