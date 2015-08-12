require_relative '../acceptance_helper'

feature 'User can be authenticated via twitter', %q{
        In order to register or log in
        As a guest
        I want to be able to register using twitter oauth
} do

  describe 'twitter' do
    before do
      mock_auth_hash
    end

    given(:sign_in_with_twitter) do
      visit new_user_session_path
      click_link 'Sign in with Twitter'
    end

    given(:fill_fields) do
      fill_in 'user_email', with: 'test@gmail.com'
      fill_in 'user_password', with: '12345678'
      fill_in 'user_password_confirmation', with: '12345678'
      click_on 'Continue'
    end

    scenario 'redirects to validate_sign_up page' do
      sign_in_with_twitter

      expect(page).to have_content('To complete registration fill the following fields')
    end

    scenario 'redirects to confirm page after user fills email and password' do
      visit new_user_session_path
      sign_in_with_twitter
      fill_fields

      expect(page).to have_content('Resend confirmation instructions')
    end

    scenario 'an confirm email' do
      clear_emails

      sign_in_with_twitter
      fill_fields

      open_email('test@gmail.com')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed'
    end

    scenario 'not allowed to log in at second attempt without email confirmation' do
      sign_in_with_twitter
      fill_fields
      click_on('Sign in with Twitter')
      expect(page).to have_content 'You have to confirm your email address before continuing. '
    end
  end
end