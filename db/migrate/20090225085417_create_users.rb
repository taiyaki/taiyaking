class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :nickname
      t.string :email
      t.string :claimed_url
      t.string :fullname
      t.string :birth_date
      t.integer :gender
      t.string :postcode
      t.string :country
      t.string :language
      t.string :timezone

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
