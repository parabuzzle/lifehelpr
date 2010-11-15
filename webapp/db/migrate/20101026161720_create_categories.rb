class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :user_id, :int, :null => false
      t.column :name, :string, :null => false
      t.timestamps
    end
    add_column "todos", "category_id", :int
  end

  def self.down
    drop_table :categories
    remove_column "todos", "category_id"
  end
end
