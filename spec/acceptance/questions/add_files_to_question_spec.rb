require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question' do
    fill_in 'Title', with: 'New title'
    fill_in 'Text question', with: 'New text'
    attach_file 'File', "#{Rails.root}/public/robots.txt"
    click_on 'Save'

    expect(page).to  have_link 'robots.txt', href: '/uploads/attachment/file/1/robots.txt'
  end
end