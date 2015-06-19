require_relative '../acceptance_helper'

feature 'Create answer for question', %q{
  Create a answer to a specific question
  Can create answer to the question
  The user creates answer to the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user can create a answer', js:true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Enter your answer:', with: 'Example body text'
    click_on 'Save answer'

    expect(page).to have_content 'Your answer successfully created'
    expect(page).to have_content 'Example body text'
  end

  scenario 'Non-authenticated user ties to create answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Create new answer'
    expect(page).to_not have_content 'Enter your answer'
    expect(page).to_not have_content 'Save answer'
  end
end
