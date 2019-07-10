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

    it 'creates new account with Voice option for 2FA', voice: true do
      visit_idp_from_oidc_sp
      click_on 'Create an account'
      create_new_account_with_voice

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

    it 'creates new account with Voice option for 2FA', voice: true do
      visit_idp_from_saml_sp
      click_on 'Create an account'
      create_new_account_with_voice

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
    expect(current_path).to eq '/sign_up/completed'

    click_on 'Continue'

    if usa_jobs_urls.include?(oidc_sp_url)
      expect(current_url).to match(%r{https://.*usajobs\.gov})
    else
      expect(current_url).to match(%r{https://sp})
      expect(page).to have_content(email_address)
    end
  end

  def expect_user_is_redirected_to_saml_sp
    expect(current_path).to eq '/sign_up/completed'

    click_on 'Continue'

    expect(current_url).to match(%r{https://sp})
    expect(page).to have_content(email_address)
  end
end
