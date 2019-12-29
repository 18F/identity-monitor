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

    it 'creates new IAL2 account with SMS option for 2FA' do
      visit_idp_from_oidc_sp_with_ial2
      expect(page).to have_content 'You will also need'
      click_on 'Create an account'
      create_new_account_with_sms
      expect(page).to have_current_path('/verify/doc_auth/welcome')

      page.execute_script("document.getElementById('ial2_consent_given').click()")
      expect(page).to have_button('Continue', disabled: false)

      click_on 'Continue'
      expect(page).to have_current_path('/verify/doc_auth/upload')

      click_on 'Use your computer'
      expect(page).to have_current_path('/verify/doc_auth/front_image')

      attach_file 'doc_auth_image', File.expand_path('spec/fixtures/mont-front.jpeg')
      click_on 'Continue'
      expect(page).to have_current_path('/verify/doc_auth/back_image')

      attach_file 'doc_auth_image', File.expand_path('spec/fixtures/mont-back.jpeg')
      click_on 'Continue'
      expect(page).to have_current_path('/verify/doc_auth/ssn')

      fill_in 'doc_auth_ssn', with: '%010d' % rand(10**10)
      click_on 'Continue'
      expect(page).to have_current_path('/verify/doc_auth/verify')

      click_on 'Continue'
      expect(page).to have_current_path('/verify/doc_auth/doc_success')

      click_on 'Continue'
      expect(page).to have_current_path('/verify/phone')

      click_on 'Continue'
      expect(page).to have_current_path('/verify/review')

      fill_in 'Password', with: PASSWORD
      click_on 'Continue'
      expect(page).to have_current_path('/verify/confirmations')

      extra_characters_get_ignored = 'abc123qwerty'
      code_words = []
      page.all(:css, '[data-personal-key]').map do |node|
        code_words << node.text
      end
      click_on 'Continue', class: 'personal-key-continue'
      fill_in 'personal_key', with: code_words.join('-').downcase + extra_characters_get_ignored
      click_on 'Continue', class: 'personal-key-confirm'
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
