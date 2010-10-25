class AddArchiveStatus < ActiveRecord::Migration
    def self.up
      add_column "todos", "archived", :boolean, :null => false, :default => false
    end

    def self.down
      remove_column "todos", "archived"
    end
  end
