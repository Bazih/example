require 'rails_helper'

feature 'User log out', %q{
  In order to be able to exit the system.
  As an user
  I want to be able to get out of the system.
} do

  given(:user) { create(:user) }

  scenario 'Log out the user' do
    sign_in(user)

    visit root_path
    click_on 'Signed out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
