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
    otp_sent_at = Time.now
    click_on 'Next'
    fill_in 'code', with: get_otp(otp_sent_at)
    click_on 'Submit'

    expect(page).to have_content 'Welcome'
  end
end
