class Blog < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :entry, :slug
  validates_uniqueness_of :slug
  validates_format_of :slug, :with => /^\D[0-9A-Za-z_-]+/
end
