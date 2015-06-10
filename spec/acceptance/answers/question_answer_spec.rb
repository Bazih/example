require 'rails_helper'

feature 'Answer the question', %q{
Create a answer to a specific question
Can create answer to the question
The user creates answer to the question
} do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'add answers for question' do
    visit question_path(question)
    #click_on 'Create new answer'
    fill_in 'Enter your answer:', with: 'Example body text'
    click_on 'Save answer'

    expect(page).to have_content 'Your answer successfully created'
  end
end