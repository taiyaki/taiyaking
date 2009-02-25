class BlogsController < ApplicationController
  before_filter :block_until_authorized,
    :only => [:new, :edit, :create, :update, :destory]

  def index
  end

end
