# This should run at 4:30 A.M. PST (11:30 UTC)

RAILS_ROOT=../../webapp
cd $RAILS_ROOT

script/runner ./runners/delete_old_todos.rb
script/runner ./runners/update_todo_priorities.rb