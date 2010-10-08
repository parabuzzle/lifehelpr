class Todo < ActiveRecord::Base
  belongs_to :user
  has_many :reminders
  acts_as_list :scope => :user
  default_scope :order => :position
  named_scope :undone, :conditions => { :status => false, :deleted => false }, :order => :position
  named_scope :all, :conditions => {:deleted => false}, :order => :position
  named_scope :deleted, :conditions => {:deleted => true}, :order => :modified_date
  
end
