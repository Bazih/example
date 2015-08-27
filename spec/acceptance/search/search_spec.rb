require_relative '../acceptance_helper'

feature 'User can search', %q{
    In order to find content
    As a visitor of the site
    I should be able to search information
  } do
  given!(:user) { create :user, email: 'test!@example.com' }
  given!(:users) { create_pair :user }
  given!(:questions) { create_pair :question, user: user }
  given!(:answers) { create_pair :answer, user: user }

  given!(:question) { create :question, body: 'test! question', user: user }
  given!(:answer) { create :answer, body: 'test! answer', user: user }
  given!(:comment) do
    create :comment, body: 'test! comment',
           commentable: question, commentable_type: 'Question', user: user
  end

  scenario 'User searches all', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: 'test!'
      select 'All', from: 'search_filter'
      save_and_open_page
      click_on 'Search'

      within '.result' do
        expect(page).to have_content question.body
        expect(page).to have_content answer.body
        expect(page).to have_content comment.body
        expect(page).to have_content user.email
      end
    end
  end

  scenario 'User searches question', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: 'test!'
      select 'Question', from: 'search_filter'
      click_on 'Search'

      within '.result' do
        expect(page).to have_content question.body
        expect(page).to_not have_content answer.body
        expect(page).to_not have_content comment.body
        expect(page).to_not have_content user.email
      end
    end
  end

  scenario 'User searches answer', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: 'test!'
      select 'Answer', from: 'search_filter'
      click_on 'Search'

      within '.result' do
        expect(page).to_not have_content question.body
        expect(page).to have_content answer.body
        expect(page).to_not have_content comment.body
        expect(page).to_not have_content user.email
      end
    end
  end

  scenario 'User searches comment', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: 'test!'
      select 'Comment', from: 'search_filter'
      click_on 'Search'

      within '.result' do
        expect(page).to_not have_content question.body
        expect(page).to_not have_content answer.body
        expect(page).to have_content comment.body
        expect(page).to_not have_content user.email
      end
    end
  end

  scenario 'User searches user', sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: ''
      select 'User', from: 'search_filter'
      click_on 'Search'

      within '.result' do
        expect(page).to_not have_content question.body
        expect(page).to_not have_content answer.body
        expect(page).to_not have_content comment.body
        expect(page).to have_content user.email
      end
    end
  end
end