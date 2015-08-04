require_relative '../acceptance_helper'


feature 'Deleting a response by the author', %q{
  In order to be able to remove answers
  As an authenticated user
  I want to be able to delete answers
} do

  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer){ create(:answer, question: question, user: author) }
  given(:non_author) { create(:user) }

  scenario 'The authenticated user removes your answer', js: true do
    sign_in(author)

    visit questions_path
    click_on question.title
    click_on 'Delete answer'

    expect(page).to have_content 'Your Answer was successfully destroyed.'
    expect(page).to_not have_content answer.body
  end

  scenario 'Non-author of the answer tries to delete answer' do
    sign_in(non_author)

    visit questions_path
    click_on question.title

    expect(page).to have_content answer.body
    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Non-authenticated user tries to delete answer' do
    visit questions_path
    click_on question.title

    expect(page).to have_content answer.body
    expect(page).to_not have_content 'Delete answer'
  end
end
