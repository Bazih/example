require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:answers) { create_list(:answers, 2, question: question, user: user) }

    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    let(:question) { create(:question, user: @user) }
    before { get :edit, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'when valid attributes' do

      it 'saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }
            .to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'added question belongs authorized user' do
        post :create, question: attributes_for(:question)
        expect(assigns(:question).user_id).to eq subject.current_user.id
      end
    end

    context 'when invalid attributes' do
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }
            .to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'when owner question' do
      let(:question) { create(:question, user: @user) }
      context 'when valid attributes' do
        before(:each) do |ex|
          patch :update, id: question, question: attributes_for(:question),
                format: :js unless ex.metadata[:skip]
        end

        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes', skip_before: true do
          patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js
          question.reload
          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'render template' do
          patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'non-owner question' do
      let(:owner_user) { create(:user) }
      let(:question) { create(:question, user: owner_user) }
      before { patch :update, id: question, question: { title: 'new title', body: 'new body' } }

      it 'does not change question attributes'do
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq 'MyText'
      end

      it 'redirect to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'owner delete question' do
      sign_in_user
      let(:question) { create(:question, user: @user) }
      before { question }

      it 'delete question' do
        expect{ delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it 'redirect to questions path' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'non-owner delete question' do
      before { question }
      sign_in_user

      it 'does not delete question' do
        expect{ delete :destroy, id: question }.to_not change(Question, :count)
      end

      it 'redirect to root path' do
        delete :destroy, id: question
        expect(response).to redirect_to root_path
      end
    end
  end

  let(:votable_name) { described_class.controller_name.singularize.underscore.to_sym }
  let(:votable) { create(votable_name, user: user) }
  let(:current_user_votable) { create(votable_name, user: @user) }
  let(:votable_with_vote) { create(votable_name, user: user) }

  it_behaves_like 'voting'
end
