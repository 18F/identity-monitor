module IdpHelpers
  def click_send_otp
    click_on 'Send code'
  end

  def setup_backup_codes
    find("label[for='two_factor_options_form_selection_backup_code']").click
    click_on 'Continue'
    click_on 'Continue'
    click_on 'Continue'
  end

  def create_new_account_with_sms
    create_new_account_up_until_password
    find("label[for='two_factor_options_form_selection_phone']").click
    click_on 'Continue'
    fill_in 'new_phone_form_phone', with: GOOGLE_VOICE_PHONE
    click_send_otp
    otp = check_for_otp
    fill_in 'code', with: otp
    uncheck 'Remember this browser'
    click_on 'Submit'
    if current_path.match(/two_factor_options_success/)
      click_on 'Continue'
      setup_backup_codes
    end
    puts "created account for #{email_address}"
    { email_address: email_address }
  end

  def create_new_account_with_totp
    create_new_account_up_until_password
    find("label[for='two_factor_options_form_selection_auth_app']").click
    click_on 'Continue'
    secret = find('#qr-code').text
    fill_in 'name', with: 'Authentication app'
    fill_in 'code', with: generate_totp_code(secret)
    click_button 'Submit'
    if current_path.match(/two_factor_options_success/)
      click_on 'Continue'
      setup_backup_codes
    end
    puts "created account for #{email_address}"
    { email_address: email_address }
  end

  def generate_totp_code(secret)
    ROTP::TOTP.new(secret).at(Time.now, true)
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

  def sign_in_and_2fa(creds)
    fill_in 'user_email', with: creds[:email_address]
    fill_in 'user_password', with: PASSWORD
    # Once the new sign in screen has been deployed to prod (2020/04/09) this
    # can be replaced with `click_on 'Sign in'`
    page.find('#new_user input[type=submit]').click
    fill_in 'code', with: check_for_otp
    uncheck 'Remember this browser'
    click_on 'Submit'
  end
end
