# This should be run every hour at :31

cd $LIFEHELPR_ROOT

hour=`date -u +%H`
min="30"

script/runner ./runners/send_todo_reminders.rb $hour $min