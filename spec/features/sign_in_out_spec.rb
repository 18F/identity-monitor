require 'spec_helper'

describe 'sign in and out' do
  before { inbox_clear }

  it 'creates account, signs out, signs back in' do
    creds = create_new_account

    visit idp_logout_url
    visit idp_signin_url

    fill_in 'user_email', with: creds[:email_address]
    fill_in 'user_password', with: PASSWORD
    click_on 'Next'

    otp = check_for_otp
    fill_in 'code', with: otp
    click_on 'Submit'

    expect(page).to have_content 'Welcome'
  end
end
