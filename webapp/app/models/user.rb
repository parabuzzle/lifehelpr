class User < ActiveRecord::Base
  acts_as_authentic
  #attr_accessor :email, :crypted_password, :remember_token
  
  has_one :setting
  has_many :beta_invites
  has_many :todos
  
end