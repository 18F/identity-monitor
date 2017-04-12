# use . in include path
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../.'
require 'json'
require 'pp'
require 'dotenv'
require 'gmail'
require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 5

Dir['spec/support/**/*.rb'].sort.each { |file| require file }

RSpec.configure do |config|
  config.color = true
  config.order = :random

  # config.infer_spec_type_from_file_location is a Rails-only feature,
  # so we do it ourselves.
  config.define_derived_metadata(file_path: %r{/spec/features}) do |metadata|
    metadata[:type] = :feature
    metadata[:js] = true
  end

  config.include GmailHelpers
  config.include IdpHelpers

  config.before(:each) do
    inbox_clear
  end
end

Dotenv.load

PASSWORD = 'salty pickles'.freeze
EMAIL = ENV['EMAIL']
EMAIL_PASSWORD = ENV['EMAIL_PASSWORD']
PHONE = ENV['PHONE']
if !EMAIL || !EMAIL_PASSWORD || !PHONE
  abort('Must set EMAIL EMAIL_PASSWORD and PHONE env vars -- did you create a .env file?')
end

##############################################################################
# helper methods

def idp_signin_url
  ENV['IDP_URL']
end

def idp_signup_url
  ENV['IDP_URL'] + '/sign_up/enter_email'
end

def idp_reset_password_url
  ENV['IDP_URL'] + '/users/password/new'
end

def idp_logout_url
  ENV['IDP_URL'] + '/api/saml/logout'
end

def sp_url
  ENV['SP_URL']
end

def basic_auth_user
  URI.parse(ENV['IDP_URL']).user
end

def basic_auth_pass
  URI.parse(ENV['IDP_URL']).password
end

def random_email_address
  random_str = SecureRandom.hex(3)
  EMAIL.dup.gsub(/@/, "+#{random_str}@")
end
