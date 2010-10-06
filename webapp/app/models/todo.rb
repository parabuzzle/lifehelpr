class Todo < ActiveRecord::Base
  belongs_to :user
  has_many :reminders
  acts_as_list :scope => :user
  default_scope :order => :position
  named_scope :undone, :conditions => { :status => 0 }, :order => :position
  
end
