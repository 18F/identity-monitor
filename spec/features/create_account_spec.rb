require 'spec_helper'

describe 'create account' do
  before { inbox_clear }

  it 'creates new account with SMS option for 2FA' do
    visit idp_signup_url
    create_new_account_with_sms
  end

  it 'creates new account with Voice option for 2FA' do
    visit idp_signup_url
    create_new_account_with_voice
  end
end
