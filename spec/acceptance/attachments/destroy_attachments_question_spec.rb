require_relative '../acceptance_helper'

feature 'Delete file was question', %q{
  In order to be able to destroy file to question
  As an author
} do

  given!(:user) { create(:user) }

  background do
    sign_in(user)
  end

  scenario 'Author delete own file', js: true do
    visit new_question_path
    within '#new_question' do
      fill_in 'Title', with: 'New title'
      fill_in 'Text question', with: 'New text'
      attach_file 'File', "#{Rails.root}/public/robots.txt"
      click_on 'Save'
    end

    click_on 'Delete file'

    expect(page).to_not have_link 'robots.txt', href: "/uploads/attachment/file/1/robots.txt"
  end
end