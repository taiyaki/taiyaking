class UpgradeToDevise2 < ActiveRecord::Migration
  def up
    change_table(:users) do |t|
      t.string :encrypted_password
    end
  end

  def down
    change_table(:users) do |t|
      t.remove :encrypted_password
    end
  end
end
