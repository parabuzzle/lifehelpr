class Todo < ActiveRecord::Base
  belongs_to :user
  has_many :reminders
  acts_as_list :scope => :user
  
end
