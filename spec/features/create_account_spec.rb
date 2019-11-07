require 'spec_helper'

describe 'create account' do
  before { inbox_clear }

  context 'OIDC', unless: lower_env == 'STAGING' do
    it 'creates new account with SMS option for 2FA' do
      visit_idp_from_oidc_sp
      click_on 'Create an account'
      create_new_account_with_sms

      expect_user_is_redirected_to_oidc_sp

      log_out_from_oidc_sp
    end

    it 'creates new account with TOTP for 2FA' do
      visit_idp_from_oidc_sp
      click_on 'Create an account'
      create_new_account_with_totp

      expect_user_is_redirected_to_oidc_sp

      log_out_from_oidc_sp
    end
  end

  context 'SAML', if: lower_env == 'INT' do
    it 'creates new account with SMS option for 2FA' do
      visit_idp_from_saml_sp
      click_on 'Create an account'
      create_new_account_with_sms

      expect_user_is_redirected_to_saml_sp

      log_out_from_saml_sp
    end

    it 'creates new account with TOTP for 2FA' do
      visit_idp_from_saml_sp
      click_on 'Create an account'
      create_new_account_with_totp

      expect_user_is_redirected_to_saml_sp

      log_out_from_saml_sp
    end
  end

  def expect_user_is_redirected_to_oidc_sp
    expect(page).to have_current_path('/sign_up/completed')

    click_on 'Continue'

    if oidc_sp_is_usajobs?
      expect(page).to have_content('Welcome ')
      expect(current_url).to match(%r{https://.*usajobs\.gov})
    else
      expect(page).to have_content('OpenID Connect Sinatra Example')
      expect(current_url).to match(%r{https://sp\-oidc\-sinatra})
    end
  end

  def expect_user_is_redirected_to_saml_sp
    expect(page).to have_current_path('/sign_up/completed')

    click_on 'Continue'

    expect(page).to have_content('SAML Rails Example')
    expect(page).to have_content(email_address)
    expect(current_url).to match(%r{https://sp})
  end
end
