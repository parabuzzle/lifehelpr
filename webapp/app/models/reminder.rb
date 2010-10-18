class Reminder < ActiveRecord::Base
  belongs_to :todo
  attr_accessible :pager_email_sent, :email_sent, :email_address, :pager_email_address
end
