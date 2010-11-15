class AddPhoneCarrierOptionsToSettings < ActiveRecord::Migration
  def self.up
    add_column "settings", "phone_carrier", :string
  end

  def self.down
    remove_column "settings", "phone_carrier"
  end
end
