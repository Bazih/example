require_relative '../acceptance_helper'

feature 'Delete file was answer', %q{
  In order to be able to destroy file to answer
  As an author
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  background do
    sign_in(user)
  end

  scenario 'Author delete own file', js: true do
    visit question_path(question)
    within '.row.new_answer' do
      fill_in 'Enter your answer:', with: 'New text'
      attach_file 'File', "#{Rails.root}/public/robots.txt"
      click_on 'Save'
    end

    within '.answers' do
      click_on 'Delete file'
    end
    expect(page).to_not have_link 'robots.txt', href: "/uploads/attachment/file/1/robots.txt"
  end
end