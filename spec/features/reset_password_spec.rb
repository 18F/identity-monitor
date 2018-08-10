require 'spec_helper'

describe 'password reset' do
  before { inbox_clear }

  it 'resets password at LOA1' do
    visit idp_reset_password_url
    fill_in 'password_reset_email_form_email', with: ENV['SMS_SIGN_IN_EMAIL']
    click_on 'Continue'

    expect(page).to have_content('Check your email')

    reset_link = check_for_password_reset_link
    visit reset_link
    fill_in 'reset_password_form_password', with: PASSWORD
    click_on 'Change password'

    expect(page).to have_content('Your password has been changed')
  end
end
