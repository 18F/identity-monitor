# frozen_string_literal: true
require 'capybara'
require 'capybara/rspec'
require 'capybara/webkit'
require 'dotenv'
require 'rspec/webservice_matchers'

Dotenv.load

Capybara.javascript_driver = :webkit
Capybara.run_server        = false

Capybara::Webkit.configure(&:allow_unknown_urls)

module IdentityMonitor
  module Spec
    module_function

    def new_session
      Capybara::Session.new(:webkit)
    end
  end
end
