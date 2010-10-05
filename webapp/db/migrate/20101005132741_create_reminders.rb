class CreateReminders < ActiveRecord::Migration
  def self.up
    create_table :reminders do |t|
      t.column :todo_id, :int
      t.column :pager_email_sent, :boolean, :default =>false
      t.column :email_sent, :boolean, :default =>false
      t.column :email_address, :string
      t.column :pager_email_address, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :reminders
  end
end
