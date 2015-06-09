require 'rails_helper'

feature 'Answer the question' do

  given!(:question) { create(:question) }

  scenario 'add answers for question' do
    visit questions_path
    save_and_open_path
    click_on

  end
end