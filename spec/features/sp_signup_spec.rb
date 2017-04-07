require 'spec_helper'

describe 'SP initiated sign up' do
  it 'creates new account via SP' do
    page.driver.basic_authorize(basic_auth_user, basic_auth_pass)

    visit sp_url
    find(:css, 'button').click

    expect(current_url).to match(/https:\/\/idp/)

    click_on 'Get started'

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

    puts "created account for #{email_address} with personal key: #{code_words.join('-')}"

    expect(current_path).to eq '/sign_up/completed'

    click_on 'Continue to Demo SP Application'

    expect(current_url).to match(/https:\/\/sp/)
  end
end
