require 'spec_helper'

describe 'SP initiated sign up' do
  before { inbox_clear }

  it 'creates new account via SP' do
    visit sp_url
    find(:css, '.btn').click

    expect(current_url).to match(%r{https://idp})

    click_on 'Create an account'
    create_new_account_with_sms

    expect(current_path).to eq '/sign_up/completed'

    click_on 'Continue'

    expect(current_url).to match(%r{https://sp})
    expect(page).to have_content(email_address)
  end
end
