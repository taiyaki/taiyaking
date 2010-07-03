class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    users = User.all.sort_by do |user|
      user.id
    end.collect do |user|
      attributes = user.attributes
      attributes[:identity_url] = attributes.delete(:claimed_url)
    end
    p users

    drop_table :users
    create_table(:users) do |t|
      t.string :email
      t.string :nickname
      t.string :identity_url
      t.string :fullname
      t.string :birth_date
      t.integer :gender
      t.string :postcode
      t.string :country
      t.string :language
      t.string :timezone

      t.rememberable
      t.trackable

      t.confirmable
      t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      t.token_authenticatable

      t.timestamps
    end

    add_index :users, :identity_url,         :unique => true
    add_index :users, :email,                :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :unlock_token,         :unique => true

    users.each do |user|
      User.create(user)
    end
  end

  def self.down
    drop_table :users
  end
end
