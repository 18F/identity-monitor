require 'spec_helper'

describe 'SP initiated sign in' do
  before { inbox_clear }

  it 'redirects back to SP' do
    visit idp_signup_url
    creds = create_new_account_with_sms
    visit idp_logout_url

    visit sp_url
    if sp_url == usa_jobs_url
      click_button 'Continue'
    else
      find(:css, '.btn').click
    end

    click_on 'Sign in'

    sign_in_and_2fa(creds)
    click_on 'Continue'

    if sp_url == usa_jobs_url
      expect(current_url).to match(%r{https://.+\.uat\.usajobs\.gov})
    else
      expect(current_url).to match(%r{https://sp})
      expect(page).to have_content(email_address)
    end
  end
end
