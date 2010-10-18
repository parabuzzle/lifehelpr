class DefaultReminderSchedule < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :hour, :min, :pager, :email, :time_zone

end
