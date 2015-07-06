require_relative '../acceptance_helper'

feature 'Adding the best answer for your question', %q{
  Adding the best answer to the question
  You can choose the best answer to the question
  The owner selects the best answer to the question to him
} do

  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answers) { create_list(:answer, 5, question: question, user: author) }
  given(:non_author) { create(:user) }

  scenario 'No authenticated user wants to select the best answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link('Best answer')
    end
  end

  scenario 'An authorized user, but not the author makes the best answer' do
    sign_in(non_author)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link('Best answer')
    end
  end

  describe 'the user is the author of' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'can choose the best answer to the question', js: true do
      within '.answers'do
        within "#answer_#{answers[3].id}" do
          click_on ('Best answer')

          expect(page).to_not have_link 'Best answer'
          expect(page).to have_content 'Best'
        end

        expect(page).to have_selector('.answer:first-of-type', text: answers[3].body)
      end
    end

    scenario 'replacement better answer other answer', js: true do
      within '.answers' do

        within "#answer_#{answers[3].id}" do
          click_on 'Best answer'

          expect(page).to_not have_link 'Best answer'
          expect(page).to have_content 'Best'
        end

        within "#answer_#{answers[4].id}" do
          click_on 'Best answer'

          expect(page).to_not have_link 'Best answer'
          expect(page).to have_content 'Best'
        end
      end
    end
  end
end