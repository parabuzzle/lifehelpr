class CreateDefaultReminderSchedules < ActiveRecord::Migration
  def self.up
    create_table :default_reminder_schedules do |t|
      t.column :user_id, :int, :null => false
      t.column :hour, :int, :null => false, :default => 0
      t.column :min, :int, :null => false, :default => 0
      t.column :pager, :boolean, :null => false, :default => false
      t.column :email, :boolean, :null => false, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :default_reminder_schedules
  end
end
