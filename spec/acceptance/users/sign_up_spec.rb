require_relative '../acceptance_helper'

feature 'User sign up', %q{
  To create questions and answers
  As an user
  I want to be able to register
} do

  scenario 'User registration successful' do
    clear_emails

    attributes = attributes_for(:user)
    sign_up(attributes)

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address'

    open_email(attributes[:email])
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed'
  end
end
