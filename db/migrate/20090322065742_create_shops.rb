class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
      t.string :name
      t.string :address
      t.string :tel
      t.string :opening_hours
      t.string :shop_holiday
      t.string :web_site
      t.string :near_station

      t.timestamps
    end
  end

  def self.down
    drop_table :shops
  end
end
