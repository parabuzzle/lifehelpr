# This script deletes finished todo items after a day

logger = RAILS_DEFAULT_LOGGER
logger.info("[todo deleter] starting todos deleter")
@todos = Todo.for_delete
logger.info("[todo deleter] Found #{@todos.length} todos to delete")
@todos.each do |todo|
  todo.deleted = true
  todo.save
end
logger.info("[todo deleter] Finished")
RAILS_DEFAULT_LOGGER.flush