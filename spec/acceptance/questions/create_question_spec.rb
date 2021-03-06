require_relative '../acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user can create a question', js: true do
    sign_in(user)

    visit questions_path
    click_on 'Create question'
    fill_in 'Title', with: 'New title'
    fill_in 'Text question', with: 'New text'
    click_on 'Save'

    expect(page).to have_content 'Question successfully created!'
    expect(page).to have_content 'New title'
    expect(page).to have_content 'New text'
    expect(current_path).to eq question_path(Question.last)
  end

  scenario 'Non-authenticated user ties to create question', js: true do
    visit questions_path

    expect(page).to_not have_link 'Save'
  end
end
