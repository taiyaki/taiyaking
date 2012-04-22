class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    users = User.all.sort_by do |user|
      user.id
    end.collect do |user|
      attributes = user.attributes
      attributes["identity_url"] = attributes.delete("claimed_url")
      attributes
    end
    (Rails.root + "tmp" + "users.yaml").open("w") do |file|
      file.puts(users.to_yaml)
    end

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

      t.datetime :remember_created_at

      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      t.integer  :failed_attempts, :default => 0
      t.string   :unlock_token
      t.datetime :locked_at

      t.string :authentication_token

      t.timestamps
    end

    add_index :users, :identity_url,         :unique => true
    add_index :users, :email,                :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :unlock_token,         :unique => true
  end

  def self.down
    drop_table :users
  end
end
