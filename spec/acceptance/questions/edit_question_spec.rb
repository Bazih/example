require_relative '../acceptance_helper'

feature 'Edit your question', %q{
  In order to be able to edit questions
  As an authenticated user
  I want to be able to edit questions
} do

  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:non_author) { create(:user) }


  scenario 'Non-authenticated user edit question' do
    visit question_path(question)

    expect(page).to_not have_link('Edit question')
  end

  scenario "The user is authenticated, but isn't the author" do
    sign_in(non_author)
    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    expect(page).to_not have_link('Edit question')
  end
  describe 'The authenticated author' do
    background do
      sign_in(author)
      visit question_path(question)
      click_on 'Edit question'
    end

    scenario 'when data are valid', js: true do
      fill_in 'Title', with: 'Updated title'
      fill_in 'Text question', with: 'Updated text'
      click_on 'Save'

      expect(page).to have_content 'Question was successfully updated.'
      expect(page).to have_content 'Updated title'
      expect(page).to have_content 'Updated text'
    end

    scenario 'when the data is not valid', js: true do
      fill_in 'Title', with: ''
      fill_in 'Text question', with: ''
      click_on 'Save'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end
end
