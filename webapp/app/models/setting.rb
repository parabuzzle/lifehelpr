class Setting < ActiveRecord::Base
  belongs_to :user
  attr_accessor :first_name, :last_name, :pager_email, :email_reminders, :page_reminders, :marketing_mail, :time_zone
  
  before_create :set_time_zone_default
  
  def set_time_zone_default
    self.time_zone = "Pacific Time (US & Canada)"
  end
  
  def pager_email_activation_code
  end
  
  def send_page?
    if self.pager_email_active
      if self.page_reminders
        return true
      end
    end
    return false
  end
  
  def send_rem_email?
    if self.email_reminders
      return true
    end
    return false
  end
  
end
