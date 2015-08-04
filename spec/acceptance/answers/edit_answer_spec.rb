require_relative '../acceptance_helper'

feature 'Edit answer', %q{
  In order to fix mistake
  As an author answer
  I want to be able edit my answer
} do

  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given(:non_author) { create(:user) }

  scenario 'Non-authenticated user edit answer' do
    visit question_path(question)

    expect(page).to_not have_link('Edit answer')
  end

  scenario 'User authentication, but does not edit the author of an answer' do
    sign_in(non_author)
    visit question_path(question)

    expect(page).to have_content(answer.body)
    expect(page).to_not have_link('Edit answer')
  end

  describe 'The authenticated author' do
    background do
      sign_in(author)
      visit question_path(question)
      click_on 'Edit answer'
    end

    scenario 'when data are valid', js: true do
      within '.answers' do
        fill_in 'Text answer', with: 'Updated text'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Updated text'
        expect(page).to_not have_selector 'textarea'
      end
      expect(page).to have_content 'Answer was successfully updated.'
    end

    scenario 'when the data is not valid', js: true do
      within '.answers' do
        fill_in 'Text answer', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content answer.body
      end
    end
  end
end