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

  def welcome(user, sent_at=Time.now)
    subject    'Welcome to LifeHelpr.com'
    recipients user.email
    from @@mail['from']
    sent_on    sent_at
    content_type "text/html"
    body       :user => user, :host => @@mail['host'], :footer =>@@mail['footer']
  end

  def forgot_password(user, sent_at=Time.now)
    subject    'LifeHelpr password information'
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
