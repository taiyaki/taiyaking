class AddToIndexNameFromShops < ActiveRecord::Migration
  def self.up
    add_index :shops, :name, :unique
  end

  def self.down
    remove_index :shops, :name
  end
end
