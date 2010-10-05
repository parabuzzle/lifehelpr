class CreateBetaInvites < ActiveRecord::Migration
  def self.up
    create_table :beta_invites do |t|
      t.column :user_id, :int, :null => false
      t.column :beta_token, :string, :null => false
      t.column :email_address, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :beta_invites
  end
end
