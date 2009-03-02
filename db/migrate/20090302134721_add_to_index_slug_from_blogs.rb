class AddToIndexSlugFromBlogs < ActiveRecord::Migration
  def self.up
    add_index :blogs, :slug, :unique
  end

  def self.down
    remove_index :blogs, :slug
  end
end
