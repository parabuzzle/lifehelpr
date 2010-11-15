# This should be run every hour at :01
. ~/.bash_profile
cd $LIFEHELPR_ROOT

hour=`date -u +%H`
min="00"

script/runner ./runners/send_todo_reminders.rb $hour $min
script/runner ./runners/archive_old_todos.rb