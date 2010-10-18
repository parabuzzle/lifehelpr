class ReminderSchedule < ActiveRecord::Base
  belongs_to :todo
  
  attr_accessible :hour, :min, :pager, :email, :time_zone
  
end
