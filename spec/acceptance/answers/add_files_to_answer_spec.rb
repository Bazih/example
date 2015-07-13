require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do

    sign_in(user)
    visit question_path(question)
  end

  scenario 'User add file when add answer', js: true do

    fill_in 'Enter your answer:', with: 'New answer'
    attach_file 'File', "#{Rails.root}/public/robots.txt"
    click_on 'Save'

    expect(page).to have_content 'robots.txt'
  end

  scenario 'User adds several files when ask answer', js: true do
    fill_in 'Enter your answer:', with: 'New answer'
    click_on 'add attachment'

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/public/robots.txt")
    inputs[1].set("#{Rails.root}/public/404.html")
    click_on 'Save'

    expect(page).to have_link 'robots.txt', href: '/uploads/attachment/file/1/robots.txt'
    expect(page).to have_link '404.html', href: '/uploads/attachment/file/2/404.html'
  end

end