require 'rails_helper'

feature 'View all the answers at question', %q{
  View all the answers to the question
  The user sees the answers to questions
  I want to see all the answers to the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 4, question: question, user: user) }

  scenario 'when can view all answers at question' do
    visit question_path(question)

    answers.each do |q|
      expect(page).to have_content q.body
    end
  end
end
