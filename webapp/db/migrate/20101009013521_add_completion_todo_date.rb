class AddCompletionTodoDate < ActiveRecord::Migration
  def self.up
    add_column "todos", "complete_date", :datetime
  end

  def self.down
    remove_column "todos", "complete_date" 
  end
end
