class AddFirstTimeLoginFields < ActiveRecord::Migration
  def self.up
    add_column "users", "first_time_settings", :boolean, :null => false, :default => false
    add_column "users", "first_time_login", :boolean, :null => false, :default => false
  end

  def self.down
    remove_column "users", "first_time_settings"
    remove_column "users", "first_time_login"
  end
end
