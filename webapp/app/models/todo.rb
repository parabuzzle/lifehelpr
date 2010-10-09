class Todo < ActiveRecord::Base
  belongs_to :user
  has_many :reminders
  acts_as_list :scope => :user
  default_scope :order => :position
  named_scope :undone, :conditions => { :status => false, :deleted => false }, :order => :position
  named_scope :all, :conditions => {:deleted => false}, :order => :position
  named_scope :deleted, :conditions => {:deleted => true}, :order => :updated_at
  named_scope :top5, :conditions => {:deleted => false, :status => false }, :order => :position, :limit => 5
  named_scope :last_week_closed, :conditions => {:status=>true, :deleted => false, :complete_date => 7.days.ago..Time.now.utc}, :order => :complete_date
  named_scope :last_week_open, :conditions => {:status=>false, :deleted => false, :created_at => 7.days.ago..Time.now.utc}, :order => :position
  named_scope :last_week_created, :conditions => {:deleted => false, :created_at => 7.days.ago..Time.now.utc}, :order => :position
  
  
end
