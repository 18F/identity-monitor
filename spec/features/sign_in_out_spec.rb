require 'spec_helper'

describe 'sign in and out' do
  before { inbox_clear }

  it 'creates account, signs out, signs back in' do
    visit idp_signup_url
    creds = create_new_account_with_sms

    visit idp_logout_url
    visit idp_signin_url
    sign_in_and_2fa(creds)

    expect(page).to have_content 'Welcome'
  end
end
