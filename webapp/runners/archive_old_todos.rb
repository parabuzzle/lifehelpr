# This script deletes finished todo items after a day

logger = RAILS_DEFAULT_LOGGER
logger.info("[todo archiver] starting todos deleter")
@todos = Todo.for_archive
logger.info("[todo archiver] Found #{@todos.length} todos to archive")
@todos.each do |todo|
  todo.archived = true
  todo.save
end
logger.info("[todo archiver] Finished")
RAILS_DEFAULT_LOGGER.flush