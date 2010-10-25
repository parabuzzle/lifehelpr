class Todo < ActiveRecord::Base
  belongs_to :user
  has_many :reminders
  has_many :reminder_schedules
  
  acts_as_list :scope => :user
  
  attr_accessible :name, :notes, :status, :duedate, :deleted, :email_reminder, :page_reminder, :position, :complete_date
  
  #always order by position unless I say otherwise :)
  default_scope :order => :position
  #return all unfinished todos
  named_scope :undone, :conditions => { :status => false, :deleted => false, :archived => false }, :order => :position
  #return all todos that are not deleted or archived
  named_scope :all, :conditions => {:deleted => false, :archived => false}, :order => :position
  #return all todos that not deleted
  named_scope :all_with_archive, :conditions=>{:deleted=>false}, :order=>:position
  #return all deleted todos (This is an admin scope)
  named_scope :deleted, :conditions => {:deleted => true}, :order => :updated_at
  #return all the archived todos
  named_scope :archived, :conditions => {:deleted => false, :archived => true}, :order => :updated_at
  #return the top5 unfinished todos
  named_scope :top5, :conditions => {:deleted => false, :archived => false, :status => false }, :order => :position, :limit => 5
  #return the todos that were closed in the last week
  named_scope :last_week_closed, :conditions => {:status=>true, :deleted=>false, :complete_date => 7.days.ago..Time.now.utc}, :order => :complete_date
  #return the todos that are still open and created in the last week
  named_scope :last_week_open, :conditions => {:status=>false, :deleted => false, :created_at => 7.days.ago..Time.now.utc}, :order => :position
  #return all the todos that were created last week that are not deleted
  named_scope :last_week_created, :conditions => {:deleted => false, :created_at => 7.days.ago..Time.now.utc}, :order => :position
  #return all the finished todos that not yet archived
  named_scope :for_archive, :conditions => {:status=>true, :deleted => false, :archived => false, :complete_date => 1.year.ago..Time.now-1.hour}, :order => :complete_date
  #return all todos that are due right now according to the user's timezone
  named_scope :due_now, :conditions => {:status => false, :deleted => false, :archived => false, :duedate => 5.years.ago..Time.now.midnight+23.hours+59.minutes}, :order => :position
  
end
