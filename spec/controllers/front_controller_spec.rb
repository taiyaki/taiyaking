# -*- coding: utf-8 -*-

require 'spec_helper'

describe FrontController do
  fixtures :blogs, :users

  describe "indexアクションが呼ばれたら" do
    before(:each) do
      get 'index'
    end

    it "更新状況が表示される" do
      response.should be_success
    end
  end
end
