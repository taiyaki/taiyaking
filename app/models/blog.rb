class Blog < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :entry, :slug
  validates_uniqueness_of :slug
  validates_format_of :slug, :with => /\A[a-z][0-9a-z_-]+\Z/i

  def to_param
    slug
  end
end
