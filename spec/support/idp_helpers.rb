module IdpHelpers
  def click_send_otp
    click_on 'Send code'
  end

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

  def create_new_account_with_sms
    create_new_account_up_until_password
    click_on 'Continue' # choose default SMS option
    fill_in 'user_phone_form_phone', with: TWILIO_PHONE
    otp_sent_at = Time.now
    click_send_otp
    #otp = check_for_otp(option: 'sms')
    otp = get_otp(otp_sent_at)
    fill_in 'code', with: otp
    click_on 'Submit'
    code_words = acknowledge_personal_key
    puts "created account for #{email_address} with personal key: #{code_words.join('-')}"
    { email_address: email_address, personal_key: code_words.join('-') }
  end

  def create_new_account_with_voice
    create_new_account_up_until_password
    find("label[for='two_factor_options_form_selection_voice']").click
    click_on 'Continue'
    fill_in 'user_phone_form_phone', with: TWILIO_PHONE
    otp_sent_at = Time.now
    click_send_otp
    #otp = check_for_otp(option: 'voice')
    otp = get_otp(otp_sent_at)
    puts "code is being filled with otp: #{otp}"
    fill_in 'code', with: otp
    click_on 'Submit'
    expect(page).to have_content 'personal key'
    code_words = acknowledge_personal_key
    expect(page).to have_content 'Welcome'
    puts "created account for #{email_address} with personal key: #{code_words.join('-')}"
    { email_address: email_address, personal_key: code_words.join('-') }
  end

  def create_new_account_up_until_password
    fill_in 'user_email', with: email_address
    click_on 'Submit'
    confirmation_link = check_for_confirmation_link
    puts "Visiting #{confirmation_link}"
    visit confirmation_link
    fill_in 'password_form_password', with: PASSWORD
    submit_password
  end

  def email_address
    @email_address ||= random_email_address
  end

  def submit_password
    click_on 'Continue'
  end
end
