# This should run at 4:30 A.M. PST (11:30 UTC)
. ~/.bash_profile
cd $LIFEHELPR_ROOT

script/runner ./runners/update_todo_priorities.rb