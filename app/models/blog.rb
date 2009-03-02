class Blog < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :entry, :slug
  validates_uniqueness_of :slug
end
