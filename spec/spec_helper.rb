# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/autorun'
require 'spec/rails'

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
  def user_login
    session[:user_id] = users(:tanaka).id
  end
end

module RackResponseHelpersIntegrateToTestResponse
  def invalid?;       response_code < 100 || response_code >= 600; end

  def informational?; response_code >= 100 && response_code < 200; end
  def successful?;    response_code >= 200 && response_code < 300; end
  def redirection?;   response_code >= 300 && response_code < 400; end
  def client_error?;  response_code >= 400 && response_code < 500; end
  def server_error?;  response_code >= 500 && response_code < 600; end

  def ok?;            response_code == 200;                        end
  def forbidden?;     response_code == 403;                        end
  def not_found?;     response_code == 404;                        end

  def redirect?;      [301, 302, 303, 307].include? response_code; end
  def empty?;         [201, 204, 304].include?      response_code; end
end

class Rack::Response
  include RackResponseHelpersIntegrateToTestResponse
end
