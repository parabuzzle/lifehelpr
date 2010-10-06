class Todo < ActiveRecord::Base
  belongs_to :user
  has_many :reminders
  acts_as_list :scope => :user
  default_scope :sort => :position
  named_scope :undone, :conditions => { :status => 0 }
  
end
