require 'rails_helper'

feature 'Veiw all questions', %q{
          When the user can view all questions
        } do

  given!(:questions) { create_list(:question, 2) }

  scenario 'when the user can view all questions' do
    visit questions_path

    #puts questions.map(&:title)
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end