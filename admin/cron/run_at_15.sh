# This should be run every hour at :16

RAILS_ROOT=../../webapp
cd $RAILS_ROOT

hour=`date -u +%H`
min="15"

script/runner ./runners/send_todo_reminders.rb $hour $min