require 'spec_helper'

RSpec.describe 'Login.gov Demo Site', type: :feature, js: true do
  def hostname
    'idp.demo.login.gov'
  end

  subject { hostname }

  it { should enforce_https_everywhere }
  it { should have_a_valid_cert }

  context 'initial access' do
    it 'is rejected w/out basic auth' do
      session = IdentityMonitor.new_session
      session.visit("https://#{hostname}")

      expect(session.status_code).to be 401
    end

    it 'is accepted w/ proper basic auth login' do
      session = IdentityMonitor.new_session
      user = ENV.fetch('BASIC_AUTH_USERNAME')
      pass = ENV.fetch('BASIC_AUTH_PASSWORD')

      session.visit("https://#{user}:#{pass}@#{hostname}")

      expect(session.status_code).to be 200
    end
  end

  describe 'creating an account' do
    it 'has a link trail to the sign-up page' do
      session = IdentityMonitor.new_session
      user = ENV.fetch('BASIC_AUTH_USERNAME')
      pass = ENV.fetch('BASIC_AUTH_PASSWORD')

      session.visit("https://#{user}:#{pass}@#{hostname}")
      session.click_link('Create account')
      session.click_link('Get started')
    end
  end
end
