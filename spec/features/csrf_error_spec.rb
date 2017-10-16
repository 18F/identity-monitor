require 'spec_helper'

describe 'CSRF errors' do
  it 'does not show any errors' do
    visit idp_reset_password_url

    expect(page).to have_content('Forgot')

    fill_in 'password_reset_email_form_email', with: 'fake-email@login.gov'

    page.driver.browser.remove_cookie 'AWSALB'

    click_on 'Continue'

    expect(page).to_not have_content('Oops')
  end
end
