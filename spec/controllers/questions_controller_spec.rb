require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before do
      get :index
    end

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    it 'assigns the requested to @question' do
      get 'show', id: question
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      get 'show', id: question
      expect(response).to render_template :show
    end
  end
end
