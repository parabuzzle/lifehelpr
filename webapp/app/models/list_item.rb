class ListItem < ActiveRecord::Base
  belongs_to :list
  acts_as_list :scope => :list
  
  default_scope :order => :position
end
