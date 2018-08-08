# use . in include path
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../.'

require 'capybara/rspec'
require 'dotenv'
require 'gmail'
require 'json'
require 'pp'
require 'selenium/webdriver'
require 'twilio-ruby'

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu] }
  )

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities
end

Capybara.javascript_driver = :headless_chrome
Capybara.default_max_wait_time = 5

Dir['spec/support/**/*.rb'].sort.each { |file| require file }

Dotenv.load

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
  config.include SpHelpers
  config.include TwilioHelpers

  config.before(:each) do
    inbox_clear
  end
end

EMAIL = ENV['EMAIL']
EMAIL_PASSWORD = ENV['EMAIL_PASSWORD']
GOOGLE_VOICE_PHONE = ENV['GOOGLE_VOICE_PHONE']
PASSWORD = 'salty pickles'.freeze
TWILIO_PHONE = ENV['TWILIO_PHONE']
TWILIO_SID = ENV['TWILIO_SID']
TWILIO_TOKEN = ENV['TWILIO_TOKEN']

if !EMAIL || !EMAIL_PASSWORD || !TWILIO_PHONE || !TWILIO_SID || !TWILIO_TOKEN
  abort('Must set EMAIL EMAIL_PASSWORD, TWILIO_PHONE, TWILIO_SID, and TWILIO_TOKEN env vars -- did'\
  ' you create a .env file?')
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

def random_email_address
  random_str = SecureRandom.hex(3)
  EMAIL.dup.gsub(/@/, "+#{random_str}@")
end
