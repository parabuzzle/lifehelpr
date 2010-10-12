# This script updates the sort order of todo items based
# on the duedates of the items

logger = RAILS_DEFAULT_LOGGER
logger.info("[todo priority adjuster] starting priority adjustment")
#get all items due and overdue
all_duenow = Todo.due_now
logger.info("[todo priority adjuster] found #{all_duenow.length} due and over due items")

i = 0
#adujust priority by -10000
all_duenow.each do |todo|
  unless todo.position.negative?
    todo.position = todo.position-10000
    todo.save
    i = i + 1
  end
end

logger.info("[todo priority adjuster] Finished (adjusted #{i} items)")
RAILS_DEFAULT_LOGGER.flush