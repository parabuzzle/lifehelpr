class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :email, :string, :null => false
      t.column :crypted_password, :string
      t.column :password_salt, :string
      t.column :persistence_token, :string
      t.column :remember_token, :string
      t.column :perishable_token, :string
      t.column :beta_token, :string
      t.column :login_count, :integer, :null => false, :default => 0
      t.column :failed_login_count, :integer, :null => false, :default => 0
      t.column :last_request_at, :datetime
      t.column :current_login_at, :datetime
      t.column :last_login_at, :datetime
      t.column :current_login_ip, :string
      t.column :last_login_ip, :string
      t.column :invites, :int, :default => 0
      t.column :is_admin, :boolean, :null => false, :default =>false
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
