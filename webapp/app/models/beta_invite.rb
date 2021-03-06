class BetaInvite < ActiveRecord::Base
  belongs_to :user
  before_create :make_beta_token, :check_available
  attr_accessible :from_name, :from_email, :friend_name, :email_address, :beta_token
  attr_accessor :from_name, :from_email, :friend_name
  def check_available
    if self.user.invites > self.user.beta_invites.count
      return true
    else
      return false
    end
  end

  def invite_user
    return User.find_by_beta_token(self.beta_token)
  end
  
  def make_beta_token
    size = 4
    tok = pronouncable_random(size)
    exist = BetaInvite.find_by_beta_token(tok)
    if exist != nil
      while exist != nil
        size+=1
        tok = pronouncable_random(size)
        exist = BetaInvite.find_by_beta_token(tok)
      end
    end
    self.beta_token = tok
  end
  
end
