# This script sends reminders for todo items
logger = RAILS_DEFAULT_LOGGER

hour = ARGV[0].to_i
min = ARGV[1].to_i

logger.info("[todo reminder sender] starting for #{ARGV[0]}:#{ARGV[1]}")

reminders = DefaultReminderSchedule.find(:all, :conditions => {:hour => hour, :min => min})
logger.info("[todo reminder sender] found #{reminders.length} people with reminders")
sent = 0
reminders.each do |r|
  @user = r.user
  @todos = @user.todos.due_now
  @todos.each do |todo|
    pager_sent = false
    email_sent = false
    if r.pager
      Emails.deliver_todo_pager_reminder(@user,todo)
      logger.debug("Sent pager reminder for #{todo.name}")
      pager_sent = true
      #<Reminder id: nil, todo_id: 7, pager_email_sent: false, email_sent: false, email_address: nil, pager_email_address: nil, created_at: nil, updated_at: nil>
    end
    if r.email
      Emails.deliver_todo_email_reminder(@user,todo)
      logger.debug("Sent email reminder for #{todo.name}")
      email_sent = true
    end
    rem = todo.reminders.new
    rem.pager_email_sent = pager_sent
    rem.email_sent = email_sent
    if email_sent
      rem.email_address = @user.email
    end
    if pager_sent
      rem.pager_email_address = @user.setting.pager_email
    end
    rem.save
    sent = sent + 1
  end
end    

logger.info("[todo reminder sender] Finished - sent #{sent} reminders")
RAILS_DEFAULT_LOGGER.flush