require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) {create (:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }


  describe 'POST #create' do
    sign_in_user

    context 'when valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) if subject.current_user }
            .to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to(assigns(:question))
      end
    end

    context 'when invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }
            .to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to redirect_to(assigns(:question))
      end
    end
  end

  describe 'GET #edit' do
    sign_in_user
    let(:answer) { create(:answer, question: question, user: @user) }
    before { get :edit, id: answer, question_id: question }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'update is owner user' do
      let(:answer) { create(:answer, question: question, user: @user) }

      context 'when valid attributes' do
        before { patch :update, id: answer, question_id: question, answer: { body: 'new body' } }

        it 'assigns the requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'change answer attributes' do
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'redirects to the updated answer' do
          expect(answer).to redirect_to question
        end
      end

      context 'when invalid attributes' do
        before { patch :update, id: answer, question_id: question, answer: { body: nil } }

        it 'does not change answer attributes' do
          answer.reload
          expect(answer.body).to eq answer.body
        end

        it 're-render edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'update is non owner user' do
      before { patch :update, question_id: question, id: answer, answer: { body: 'text body' } }

      it 'does not change answer attributes'do
        question.reload
        expect(answer.body).to eq answer.body
      end

      it 'redirect to question' do
        expect(response).to redirect_to question_path
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'owner delete question' do
      sign_in_user
      let(:answer) { create(:answer, question: question, user: @user) }
      before { answer }

      it 'deletes answer' do
        expect { delete :destroy, id: answer, question_id: question }
            .to change(Answer, :count).by(-1)
      end

      it 'redirect to question view' do
        delete :destroy, id: answer
        expect(response).to redirect_to question
      end
    end

    context 'non-owner delete question' do
      before { answer }
      sign_in_user

      it 'does not delete question' do
        expect{ delete :destroy, id: answer, question_id: question }
            .to_not change(Answer, :count)
      end

      it 'redirect to root path' do
        delete :destroy, id: answer
        expect(response).to redirect_to question_path
      end
    end
  end

end
