require 'spec_helper'

describe 'SP initiated sign in' do
  before { inbox_clear }

  context 'OIDC', unless: lower_env == 'STAGING' do
    xit 'redirects back to SP' do
      visit_idp_from_oidc_sp
      creds = { email_address: EMAIL }
      sign_in_and_2fa(creds)

      if oidc_sp_is_usajobs?
        expect(page).to have_content('Welcome ')
        expect(current_url).to match(%r{https://.*usajobs\.gov})
      else
        expect(page).to have_content('OpenID Connect Sinatra Example')
        expect(current_url).to match(%r{https://sp-oidc-sinatra})
      end

      log_out_from_oidc_sp
    end
  end

  context 'SAML', if: lower_env == 'INT' do
    it 'redirects back to SP' do
      visit_idp_from_saml_sp
      creds = { email_address: EMAIL }
      sign_in_and_2fa(creds)

      expect(page).to have_content('SAML Rails Example')
      expect(page).to have_content(EMAIL)
      expect(current_url).to match(%r{https://sp})

      log_out_from_saml_sp
    end
  end
end
