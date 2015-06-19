require_relative '../acceptance_helper'

feature 'Veiw all questions', %q{
  View all issues
  Browse all the questions, not to be repeated
  User to view all questions
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2, user: user) }

  scenario 'when the user can view all questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
