module SpHelpers
  def usa_jobs_urls
    [
      'https://login.uat.usajobs.gov/Access/Transition',
      'https://login.usajobs.gov/Access/Transition'
    ]
  end

  def visit_idp_from_oidc_sp
    visit oidc_sp_url
    if usa_jobs_urls.include?(oidc_sp_url)
      click_button 'Continue'
    else
      find(:css, '.btn').click
    end

    expect(current_url).to match(%r{https://(idp|secure\.login\.gov)})
  end

  def visit_idp_from_saml_sp
    visit saml_sp_url
    find(:css, '.btn').click

    expect(current_url).to match(%r{https://(idp|secure\.login\.gov)})
  end

  def log_out_from_oidc_sp
    if usa_jobs_urls.include?(oidc_sp_url)
      within('.usajobs-home__title') do
        click_link 'Sign Out'
      end
      expect(current_url).to match(%r{https://login.(uat.)?usajobs.gov/externalloggedout})
    else
      click_on 'Log out'
      expect(current_url).to match oidc_sp_url
      expect(page).to_not have_content 'Log out'
      expect(page).to_not have_content 'Email'
    end
  end

  def log_out_from_saml_sp
    click_on 'Log out'
    expect(current_url).to match saml_sp_url
    expect(page).to have_content 'Logout successful'
  end
end
