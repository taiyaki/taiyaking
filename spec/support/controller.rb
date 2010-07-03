module UserControllerExampleMethods
  include Devise::TestHelpers

  class << self
    def included(base)
      base.module_eval do
        before(:each) do
          warden
        end
      end
    end
  end

  def user_login
    sign_in(:user, users(:tanaka))
  end
end
