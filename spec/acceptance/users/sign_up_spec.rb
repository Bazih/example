require_relative '../acceptance_helper'

feature 'User sign up', %q{
  To create questions and answers
  As an user
  I want to be able to register
} do

  scenario 'User registration successful' do
    visit root_path
    click_on 'Sign up'

    user_attrs = attributes_for(:user)
    fill_in 'Email', with: user_attrs[:email]
    fill_in 'Password', with: user_attrs[:password]
    fill_in 'Password confirmation', with: user_attrs[:password_confirmation]
    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
