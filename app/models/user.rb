class User < ActiveRecord::Base
  has_many :blogs
end
