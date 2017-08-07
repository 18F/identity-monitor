module IdpHelpers
  def click_send_otp
    click_on 'Send security code'
  end

  # rubocop:disable MethodLength
  def acknowledge_personal_key
    code_words = []

    page.all(:css, '[data-personal-key]').map do |node|
      code_words << node.text
    end

    button_text = 'Continue'
    click_on button_text, class: 'personal-key-continue'
    fill_in 'personal_key', with: code_words.join('-')
    click_on button_text, class: 'personal-key-confirm'
    code_words
  end

  def create_new_account
    visit idp_signup_url
    email_address = random_email_address
    fill_in 'user_email', with: email_address
    click_on 'Submit'
    confirmation_link = check_for_confirmation_link
    visit confirmation_link
    fill_in 'password_form_password', with: PASSWORD
    submit_password
    fill_in 'user_phone_form_phone', with: PHONE
    click_send_otp
    otp = check_for_otp
    fill_in 'code', with: otp
    click_on 'Submit'
    code_words = acknowledge_personal_key
    expect(page).to have_content 'Welcome'
    puts "created account for #{email_address} with personal key: #{code_words.join('-')}"
    { email_address: email_address, personal_key: code_words.join('-') }
  end
  # rubocop:enable MethodLength

  def submit_password
    click_on 'Continue'
  end
end
