class List < ActiveRecord::Base
  belongs_to :user
  has_many :list_items
  acts_as_list :scope => :user
  
  default_scope :order => :position
  
end
