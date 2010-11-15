# This should be run every hour at :46
. ~/.bash_profile
cd $LIFEHELPR_ROOT

hour=`date -u +%H`
min="45"

script/runner ./runners/send_todo_reminders.rb $hour $min