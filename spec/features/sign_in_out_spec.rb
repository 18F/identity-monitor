require 'spec_helper'

describe 'sign in and out' do
  before { inbox_clear }

  it 'creates account, signs out, signs back in' do
    visit idp_signup_url
    creds = create_new_account_with_sms

    visit idp_logout_url
    visit idp_signin_url

    fill_in 'user_email', with: creds[:email_address]
    fill_in 'user_password', with: PASSWORD
    click_on 'Next'

    otp = check_for_otp(option: 'sms')
    fill_in 'code', with: otp
    click_on 'Submit'

    expect(page).to have_content 'Welcome'
  end
end
