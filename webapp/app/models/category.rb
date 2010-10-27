class Category < ActiveRecord::Base
  belongs_to :user
  has_many :todos
  
  attr_accessible :name
  
  def todos_undone
    return Todo.find(:all, :conditions => {:category_id => self.id, :status => false, :deleted => false, :archived => false})
  end
  def todos_unarchived
    return Todo.find(:all, :conditions => {:category_id => self.id, :deleted => false, :archived => false})
  end
  def todos_archived
    return Todo.find(:all, :conditions => {:category_id => self.id, :deleted => false, :archived => true})
  end
end
