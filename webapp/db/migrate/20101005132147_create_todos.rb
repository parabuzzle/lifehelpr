class CreateTodos < ActiveRecord::Migration
  def self.up
    create_table :todos do |t|
      t.column :user_id, :int, :null => false
      t.column :subject, :string
      t.column :desc, :sting
      t.column :status, :int, :null => false, :default => 0
      t.column :duedate, :datetime
      t.column :reminder_schedule, :string
      t.column :email_reminder, :boolean
      t.column :page_reminder, :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :todos
  end
end
