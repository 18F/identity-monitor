require 'spec_helper'

describe 'SP initiated sign in' do
  before { inbox_clear }

  context 'OIDC', unless: lower_env == 'STAGING' do
    it 'redirects back to SP' do
      visit_idp_from_oidc_sp
      creds = { email_address: EMAIL }
      sign_in_and_2fa(creds)

      if usa_jobs_urls.include?(oidc_sp_url)
        expect(current_url).to match(%r{https://.*usajobs\.gov})
      else
        expect(current_url).to match(%r{https://sp})
        expect(page).to have_content(EMAIL)
      end

      log_out_from_oidc_sp
    end
  end

  context 'SAML', if: lower_env == 'INT' do
    it 'redirects back to SP' do
      visit_idp_from_saml_sp
      creds = { email_address: EMAIL }
      sign_in_and_2fa(creds)

      expect(current_url).to match(%r{https://sp})
      expect(page).to have_content(EMAIL)

      log_out_from_saml_sp
    end
  end
end
