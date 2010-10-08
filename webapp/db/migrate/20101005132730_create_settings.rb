class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.column :user_id, :int, :null => false
      t.column :default_reminder_schedule, :string
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :pager_email, :string
      t.column :pager_email_token, :string
      t.column :pager_email_active, :boolean, :default => false
      t.column :email_reminders, :boolean, :null=>false, :default => true
      t.column :page_reminders, :boolean, :null=>false, :default => false
      t.column :marketing_mail, :boolean, :null=>false, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
