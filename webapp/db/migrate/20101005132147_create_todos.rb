class CreateTodos < ActiveRecord::Migration
  def self.up
    create_table :todos do |t|
      t.column :user_id, :int, :null => false
      t.column :name, :string
      t.column :notes, :string
      t.column :status, :boolean, :null => false, :default => false
      t.column :duedate, :datetime
      t.column :deleted, :boolean, :null => false, :default => false
      t.column :email_reminder, :boolean
      t.column :page_reminder, :boolean
      t.column :position, :int
      t.timestamps
    end
  end

  def self.down
    drop_table :todos
  end
end
