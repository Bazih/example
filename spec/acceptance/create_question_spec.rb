require 'rails_helper'

feature 'Create question', %q{
          I want to ask a question
        } do

  scenario 'when create question' do
    visit new_question_path
    fill_in 'Title', with: 'new_title'
    fill_in 'Text', with: 'new_body'
    click_on('Create')

    expect(page).to have_content 'Question successfully created!'
    expect(page).to have_content 'new_title'
    expect(page).to have_content 'new_body'
    expect(current_path).to eq question_path(Question.last)
  end
end
