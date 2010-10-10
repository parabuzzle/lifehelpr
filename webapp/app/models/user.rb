class User < ActiveRecord::Base
  acts_as_authentic
  #attr_accessor :password, :password_confirmation
  
  has_one :setting
  has_many :beta_invites
  has_many :todos
  has_many :default_reminder_schedules
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