require 'rails_helper'

feature 'Deleting your question', %q{
  In order to be able to remove questions
  As an authenticated user
  I want to be able to delete questions
} do

  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:non_author) { create(:user) }

  scenario 'The authenticated user removes your question' do
    sign_in(author)

    visit questions_path
    click_on 'Delete question'

    expect(page).to have_content 'Your question was successfully deleted'
    expect(page).to_not have_content(question.title)
  end

  scenario 'Non-author of the question tries to delete question' do
    sign_in(non_author)
    visit questions_path

    expect(page).to have_content question.title
    expect(page).to_not have_content 'Delete question'
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit questions_path

    expect(page).to have_content question.title
    expect(page).to_not have_content 'Delete question'
  end

end