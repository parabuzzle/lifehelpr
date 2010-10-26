class User < ActiveRecord::Base
  acts_as_authentic
  attr_accessible :email, :login, :password, :password_confirmation
  attr_accessor :old_password
  has_one :setting
  has_many :beta_invites
  has_many :todos
  has_many :default_reminder_schedules
  has_many :categories
  after_create :build_setting, :add_invites
  
  NUM_INVITES = 3
  def add_invites(num=NUM_INVITES)
    self.invites = self.invites + num
    return self.save
  end
  
  def available_invites
    return self.invites - self.beta_invites.count
  end
  
end