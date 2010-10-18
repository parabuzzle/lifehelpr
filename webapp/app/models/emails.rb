class Emails < ActionMailer::Base
  
  @@mail = SITE_PROPS['admin']['email']

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
    recipients user.setting.pager_email
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
