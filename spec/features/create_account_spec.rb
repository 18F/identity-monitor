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

  context 'OIDC', if: lower_env == 'INT' do
    it 'creates new IAL2 account with SMS option for 2FA' do
      visit_idp_from_oidc_sp_with_ial2
      verify_identity_with_doc_auth
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

    xit 'creates new IAL2 account with SMS option for 2FA' do
      visit_idp_from_saml_sp_with_ial2
      verify_identity_with_doc_auth
      expect_user_is_redirected_to_saml_sp

      log_out_from_saml_sp
    end
  end

  def expect_user_is_redirected_to_oidc_sp
    expect(page).to have_current_path('/sign_up/completed')

    # TODO(margolis) remove this branch after the next prod deploy
    if page.has_button?('Continue')
      click_on 'Continue' # production
    else
      click_on 'Agree and continue' # int
    end

    if oidc_sp_is_usajobs?
      expect(page).to have_content('Welcome ')
      expect(current_url).to match(%r{https://.*usajobs\.gov})
    else
      expect(page).to have_content('OpenID Connect Sinatra Example')
      expect(current_url).to match(%r{https:\/\/(sp|\w+-identity)\-oidc\-sinatra})
    end
  end

  def expect_user_is_redirected_to_saml_sp
    expect(page).to have_current_path('/sign_up/completed')

    # TODO(margolis) remove this branch after the next prod deploy
    if page.has_button?('Continue')
      click_on 'Continue' # production
    else
      click_on 'Agree and continue' # int
    end

    expect(page).to have_content('SAML Sinatra Example')
    expect(page).to have_content(email_address)
    expect(current_url).to match(/#{saml_sp_url}/)
  end
end
