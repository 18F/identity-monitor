require 'spec_helper'

describe 'sign in and out' do
  before { inbox_clear }

  it 'creates account, signs out, signs back in' do
    visit idp_signup_url
    creds = create_new_account_with_sms
    click_on 'Sign out'
    sign_in_and_2fa(creds)

    expect(current_url).to eq idp_signin_url + '/account'
  end
end
