class Emails < ActionMailer::Base
  
  @@mail = SITE_PROPS['admin']['email']
  
  @@carriers = {
    'AT&T' => 'txt.att.net',
    'Boost Mobile' => 'myboostmobile.com',
    'Cellular One' => 'mobile.celloneusa.com',
    'Cellular South' => 'csouth1.com',
    'Cingular GoPhone' => 'cingulartext.com',
    'Cricket' => 'sms.mycricket.com',
    'MetroPCS' => 'mymetropcs.com',
    'Nextel' => 'messaging.nextel.com',
    'Pioneer Cellular' => 'zsend.com',
    'Pocket Wireless' => 'sms.pocket.com',
    'Qwest Wireless' => 'qwestmp.com',
    'Sprint (PCS)' => 'messaging.sprintpcs.com',
    'Sprint (Nextel)' => 'page.nextel.com',
    'Straight Talk' => 'vtext.com',
    'T-Mobile' => 'tmomail.net',
    'US Cellular' => 'email.uscc.net',
    'Verizon' => 'vtext.com',
    'Virgin Mobile' => 'yrmobl.com'
  }

  def beta_invite(beta_invite, friend_name, from_name, sent_at=Time.now)
    subject    'LifeHelpr Beta Invite for You!'
    recipients beta_invite.email_address
    from @@mail['from']
    sent_on    sent_at
    content_type "text/html"
    body       :friend_name => friend_name, :from_name => from_name, :beta_invite => beta_invite, :host => @@mail['host'], :footer =>@@mail['footer']
  end
  
  def pager_activation(email, code, sent_at=Time.now)
    subject 'Activate Your Pager Mail'
    recipients email
    from @@mail['from']
    sent_on sent_at
    content_type "text/plain"
    body :code => code
  end
  
  def todo_pager_reminder(user, todo, sent_at=Time.now)
    subject "Todo Reminder #{todo.name}"
    recipients user.setting.pager_email + '@' @@carriers[user.setting.phone_carrier]
    from @@mail['from']
    sent_on sent_at
    content_type "text/plain"
    body :todo => todo
  end
  
  def todo_email_reminder(user, todo, sent_at=Time.now)
    subject "Todo Reminder #{todo.name}"
    recipients user.email
    from @@mail['from']
    sent_on sent_at
    content_type "text/html"
    body :user => user, :todo => todo, :host => @@mail['host'], :footer =>@@mail['footer']
  end
  
  def forgot_password(user, sent_at=Time.now)
    subject    'LifeHelpr password reset'
    recipients user.email
    from @@mail['from']
    sent_on    sent_at
    content_type "text/html"
    body       :user => user, :host => @@mail['host'], :footer =>@@mail['footer']
  end
  
  #Unimplemented stuff...
  def welcome(user, sent_at=Time.now)
    subject    'Welcome to LifeHelpr.com'
    recipients user.email
    from @@mail['from']
    sent_on    sent_at
    content_type "text/html"
    body       :user => user, :host => @@mail['host'], :footer =>@@mail['footer']
  end

  def change_email(user, sent_at=Time.now)
    subject    'LifeHelpr email change information'
    recipients user.email
    from @@mail['from']
    sent_on    sent_at
    content_type "text/html"
    body       :user => user, :host => @@mail['host'], :footer =>@@mail['footer']
  end

  def change_password(user, sent_at=Time.now)
    subject    'LifeHelpr password changed!'
    recipients user.email
    from @@mail['from']
    sent_on    sent_at
    content_type "text/html"
    body       :user => user, :host => @@mail['host'], :footer =>@@mail['footer']
  end

  def weekly_update(user, sent_at=Time.now)
    subject    'LifeHelpr weekly update'
    recipients user.email
    from @@mail['from']
    sent_on    sent_at
    content_type "text/html"
    body       :user => user, :host => @@mail['host'], :footer =>@@mail['footer']
  end

end
