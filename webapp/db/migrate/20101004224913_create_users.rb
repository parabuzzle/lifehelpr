class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :email, :string, :null => false
      t.column :crypted_password, :string, :null => false
      t.column :password_salt, :string, :null => false
      t.column :persistence_token, :string, :null => false
      t.column :remember_token, :string, :null => false
      t.column :login_count, :integer, :null => false, :default => 0
      t.column :failed_login_count, :integer, :null => false, :default => 0
      t.column :last_request_at, :datetime
      t.column :current_login_at, :datetime
      t.column :last_login_at, :datetime
      t.column :current_login_ip, :string
      t.column :last_login_ip, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
