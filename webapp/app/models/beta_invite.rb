class BetaInvite < ActiveRecord::Base
  belongs_to :user
  before_create :make_beta_token, :check_available
  
  def check_available
    if self.user.invites > self.user.beta_invites.count
      return true
    else
      return false
    end
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
