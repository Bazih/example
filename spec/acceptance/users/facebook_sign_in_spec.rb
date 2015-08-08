require_relative '../acceptance_helper'

feature 'User can be authenticated via facebook', %q{
        In order to register or log in
        As a guest
        I want to be able to register using facebook oauth
} do

  describe 'facebook' do
    given(:sign_in_with_facebook) do
      visit new_user_session_path
      click_link 'Sign in with Facebook'
    end

    scenario 'redirects to questions page' do
      mock_auth_hash
      sign_in_with_facebook

      expect(page).to have_content('Successfully authenticated from Facebook account.')
    end

    scenario 'can handle authentication error' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      sign_in_with_facebook
      expect(page).to have_content('Could not authenticate you from Facebook')
    end
  end
end