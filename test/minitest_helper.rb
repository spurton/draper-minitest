ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)

require "minitest/autorun"
require "capybara/rails"
require "active_support/testing/setup_and_teardown"
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  include RR::Adapters::MiniTest

  class << self
    alias context describe
  end
  
  before :each do
    DatabaseCleaner.clean
  end
  
  alias :method_name :__name__ if defined? :__name__
  
  def build_message(*args)
    args[1].gsub(/\?/, '%s') % args[2..-1]
  end
end


require "active_support/test_case"
require "action_controller/test_case"
require 'rails/test_help'


class ControllerTest < MiniTest::Spec
  
  include ActiveSupport::Testing::SetupAndTeardown
  include ActionController::TestCase::Behavior
  include Rails.application.routes.url_helpers
  
  before do
    @routes = Rails.application.routes
  end

  def self.determine_default_controller_class(name)
    if name.match(/.*(?:^|::)(\w+Controller)/)
      $1.safe_constantize
    else
      super(name)
    end
  end

  register_spec_type(/Controller/, self)
  
end

class IntegrationTest < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include Capybara::DSL
  register_spec_type(/integration$/, self)
end

class HelperTest < MiniTest::Spec
  include ActiveSupport::Testing::SetupAndTeardown
  include ActionView::TestCase::Behavior
  register_spec_type(/Helper$/, self)
end


# TODO: move ths to its own file?
module MiniTest::Expectations
  ##
  # See ActiveSupport::Testing::Assertions#assert_difference
  #
  #    proc { ... }.must_change(expression, difference = 1, message = nil)
  #
  # :method: must_change
  infect_an_assertion :assert_difference, :must_change

  ##
  # See ActiveSupport::Testing::Assertions#assert_no_difference
  #
  #    proc { ... }.wont_change(expression, message = nil)
  #
  # :method: wont_change
  infect_an_assertion :assert_no_difference, :wont_change

  ##
  # See ActiveSupport::Testing::Assertions#assert_blank
  #
  #    proc { ... }.must_be_blank(object, message = nil)
  #
  # :method: must_be_blank
  infect_an_assertion :assert_blank, :must_be_blank

  ##
  # See ActiveSupport::Testing::Assertions#assert_present
  #
  #    proc { ... }.must_be_present(object, message = nil)
  #
  # :method: must_be_present
  infect_an_assertion :assert_present, :must_be_present

  ##
  # See ActionDispatch::Assertions::ResponseAssertions#assert_redirected_to
  #
  #    must_redirect_to(options={}, message = nil)
  #
  # :method: must_redirect_to
  infect_an_assertion :assert_redirected_to, :must_redirect_to

  ##
  # See ActionDispatch::Assertions::ResponseAssertions#assert_response
  #
  #    must_respond_with(type, message = nil)
  #
  # :method: must_respond_with
  infect_an_assertion :assert_response, :must_respond_with

  ##
  # See ActionController::TemplateAssertions#assert_template
  #
  #    must_render_template(options={}, message = nil)
  #
  # :method: must_render_template
  infect_an_assertion :assert_template, :must_render_template
end
