# This script sends reminders for todo items
# It requires 2 args: hour minute
# Arguments must be in UTC
logger = RAILS_DEFAULT_LOGGER

hour = ARGV[0].to_i
min = ARGV[1].to_i
if ARGV[0].nil? || ARGV[1].nil?
  puts "Missing params"
  exit 1
end

#Ensure hour is in UTC!
diff = Time.now.utc.hour - hour
if diff > 1
  hour = Time.now.utc.hour
end
Time.zone = "UTC"
utc = Time.zone.parse("#{Time.now.year}-#{Time.now.month}-#{Time.now.day} #{hour}:#{min}")
sent = 0
logger.info("[todo reminder sender] starting for #{ARGV[0]}:#{ARGV[1]}")
tzones=['Pacific Time (US & Canada)','Mountain Time (US & Canada)','Central Time (US & Canada)','Eastern Time (US & Canada)','Hawaii','Alaska','Arizona','Indiana (East)']
tzones.each do |tzone|
  Time.zone = tzone
  local = utc.in_time_zone
  reminders = DefaultReminderSchedule.find(:all, :conditions => {:hour => local.hour, :min => local.min, :time_zone => tzone})
  logger.info("[todo reminder sender] found #{reminders.length} people with reminders in #{tzone}")
  reminders.each do |r|
    @user = r.user
    @todos = @user.todos.due_now
    @todos.each do |todo|
      pager_sent = false
      email_sent = false
      if r.pager
        if @user.setting.send_page?
          Emails.deliver_todo_pager_reminder(@user,todo)
          logger.debug("Sent pager reminder for #{todo.name}")
          pager_sent = true
        end
      end
      if r.email
        if @user.setting.send_rem_email?
          Emails.deliver_todo_email_reminder(@user,todo)
          logger.debug("Sent email reminder for #{todo.name}")
          email_sent = true
        end
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
end

logger.info("[todo reminder sender] Finished - sent #{sent} reminders")
RAILS_DEFAULT_LOGGER.flush