# use . in include path
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../.'
require 'json'
require 'pp'
require 'dotenv'
require 'gmail'
require 'capybara/rspec'
require 'webdrivers/chromedriver'
require 'rotp'
require 'pry-byebug'

Capybara.register_driver :chrome do |app|
  browser_options = Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--no-sandbox'
  browser_options.args << '--window-size=1200x700'
  browser_options.args << '--headless' if ENV['HEADLESS_BROWSER'] == 'true'
  browser_options.args << '--disable-gpu' if ENV['HEADLESS_BROWSER'] == 'true'

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 options: browser_options
end

Capybara.javascript_driver = :chrome
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

  config.example_status_persistence_file_path = './tmp/rspec-examples.txt'

  config.include GmailHelpers
  config.include IdpHelpers
  config.include IdvHelpers
  config.include SpHelpers

  config.before(:each) do
    reset_sessions
  end
end

Dotenv.load

PASSWORD = 'salty pickles'.freeze
EMAIL = ENV['EMAIL']
EMAIL_PASSWORD = ENV['EMAIL_PASSWORD']
GOOGLE_VOICE_PHONE = ENV['GOOGLE_VOICE_PHONE']
if !EMAIL || !EMAIL_PASSWORD || !GOOGLE_VOICE_PHONE
  abort(
    'Must set EMAIL EMAIL_PASSWORD and GOOGLE_VOICE_PHONE env vars -- did you create a .env file?'
  )
end

##############################################################################
# helper methods

def idp_signin_url
  ENV["#{lower_env}_IDP_URL"]
end

def idp_signup_url
  idp_signin_url + '/sign_up/enter_email'
end

def idp_reset_password_url
  idp_signin_url + '/users/password/new'
end

def idp_logout_url
  idp_signin_url + '/api/saml/logout'
end

def oidc_sp_url
  ENV["#{lower_env}_OIDC_SP_URL"]
end

def saml_sp_url
  ENV["#{lower_env}_SAML_SP_URL"]
end

def lower_env
  ENV['LOWER_ENV'].upcase
end

def random_email_address
  random_str = SecureRandom.hex(12)
  EMAIL.dup.gsub(/@/, "+#{random_str}@")
end

# Capybara.reset_session! deletes the cookies for the current site. As such
# we need to visit each site individually and reset there.
def reset_sessions
  visit idp_signin_url
  Capybara.reset_session!
  visit oidc_sp_url if oidc_sp_url
  Capybara.reset_session!
  visit saml_sp_url if saml_sp_url
  Capybara.reset_session!
end
