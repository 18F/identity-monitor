module IdvHelpers
  def verify_identity_with_doc_auth
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

    attach_file 'doc_auth_image', File.expand_path('spec/fixtures/ial2_test_credential.txt')
    click_on 'Continue'
    expect(page).to have_current_path('/verify/doc_auth/back_image')

    attach_file 'doc_auth_image', File.expand_path('spec/fixtures/ial2_test_credential.txt')
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
  end
end
