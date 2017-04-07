require 'spec_helper'

describe 'create account' do
  it 'creates new account directly' do
    visit idp_signup_url
    email_address = random_email_address
    fill_in 'user_email', with: email_address
    click_on 'Submit'
    expect(page).to have_content 'sent'

    confirmation_link = check_for_confirmation_link

    puts "Visiting #{confirmation_link}"
    visit confirmation_link
    fill_in 'password_form_password', with: PASSWORD
    click_on 'Submit'

    fill_in 'two_factor_setup_form_phone', with: PHONE
    click_send_otp

    otp = check_for_otp

    fill_in 'code', with: otp
    click_on 'Submit'

    expect(page).to have_content 'Here is your personal key'

    code_words = acknowledge_personal_key

    expect(page).to have_content 'Welcome'

    puts "created account for #{email_address} with personal key: #{code_words.join('-')}"
  end
end
