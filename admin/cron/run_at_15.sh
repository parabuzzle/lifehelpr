# This should be run every hour at :16
. ~/.bash_profile
cd $LIFEHELPR_ROOT

hour=`date -u +%H`
min="15"

script/runner ./runners/send_todo_reminders.rb $hour $min