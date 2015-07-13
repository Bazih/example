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

  scenario 'User adds files when asks question', js: true do
    fill_in 'Title', with: 'New title'
    fill_in 'Text question', with: 'New text'
    attach_file 'File', "#{Rails.root}/public/robots.txt"

    click_on 'Save'

    expect(page).to  have_link 'robots.txt', href: '/uploads/attachment/file/1/robots.txt'
  end

  scenario 'User adds several files when ask question', js: true do
    fill_in 'Title', with: 'New title'
    fill_in 'Text question', with: 'New text'
    click_on 'add attachment'

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/public/robots.txt")
    inputs[1].set("#{Rails.root}/public/404.html")
    click_on 'Save'

    expect(page).to have_link 'robots.txt', href: '/uploads/attachment/file/1/robots.txt'
    expect(page).to have_link '404.html', href: '/uploads/attachment/file/2/404.html'
  end
end