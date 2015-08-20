require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) {create (:user) }
  let!(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }


  describe 'POST #create' do
    sign_in_user

    let(:publish_path) { "/questions/#{question.id}/answers" }
    let(:request) do
      post :create, question_id: question.id, answer: attributes_for(:answer), format: :json
    end
    let(:invalid_params_request) do
      post :create, question_id: question.id, answer: attributes_for(:invalid_answer), format: :json
    end

    context 'when valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }
            .to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to be_success
      end

      it 'added question belongs authorized user' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer).user_id).to eq subject.current_user.id
      end
    end

    context 'when invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }
            .to_not change(Answer, :count)
      end

      it 'responds with error' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to be_unprocessable
      end
    end

    it_behaves_like 'publishable'
  end



  describe 'PATCH #update' do
    sign_in_user
    context 'update is owner user' do
      let(:answer) { create(:answer, question: question, user: @user) }

      context 'when valid attributes' do
        before { patch :update, id: answer, question_id: question, answer: { body: 'new body' }, format: :js }

        it 'assigns the requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'change answer attributes' do
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'render update template' do
          expect(response).to render_template :update
        end
      end
    end

    context 'update is non owner user' do
      before { patch :update, question_id: question, id: answer, answer: { body: 'text body' }, format: :js }

      it 'does not change answer attributes'do
        question.reload
        expect(answer.body).to eq answer.body
      end

      it 'redirect to question' do
        expect(response.status).to eq 403
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'owner delete question' do
      sign_in_user
      let(:answer) { create(:answer, question: question, user: @user) }
      before { answer }

      it 'deletes answer' do
        expect { delete :destroy, id: answer, question_id: question, format: :js }
            .to change(Answer, :count).by(-1)
      end

      it 'render template' do
        delete :destroy, id: answer, format: :js
        expect(answer).to render_template :destroy
      end
    end

    context 'non-owner delete question' do
      before { answer }
      sign_in_user

      it 'does not delete question' do
        expect{ delete :destroy, id: answer, question_id: question, format: :js }
            .to_not change(Answer, :count)
      end

      it 'return 403 status' do
        delete :destroy, id: answer, format: :js
        expect(response.status).to eq 403
      end
    end
  end

  describe 'POST #best' do
    sign_in_user

    let(:answer_owner) { create(:answer, question: question, user: user) }

    context 'the author of question' do
      before do
        question.update!(user: @user)
        post :best, question_id: question, id: answer_owner, format: :js
      end

      it 'make the answer the best' do
        expect(answer_owner.reload).to be_best
      end

      it 'render template best' do
        expect(response).to render_template :best
      end
    end

    context 'Not author' do

      it 'when not asker can not choose the best answer' do
        post :best, id: answer, format: :js
        expect(answer.best).to_not eq true
      end
    end
  end

  let(:votable_name) { described_class.controller_name.singularize.underscore.to_sym }
  let(:votable) { create(votable_name, question: question, user: user) }
  let(:current_user_votable) { create(votable_name, question: question, user: @user) }
  let(:votable_with_vote) { create(votable_name, question: question, user: user) }

  it_behaves_like 'voting'
end
