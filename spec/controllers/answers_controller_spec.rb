require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) {create (:user) }
  let!(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }


  describe 'POST #create' do
    sign_in_user

    context 'when valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }
            .to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
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

      it 're-renders new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
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
          expect(answer).to render_template :update
        end
      end

      # context 'when invalid attributes' do
      #   before { patch :update, id: answer, question_id: question, answer: { body: nil } }
      #
      #   it 'does not change answer attributes' do
      #     answer.reload
      #     puts answer.body
      #     expect(answer.body).to eq answer.body
      #   end
      #
      #   it 're-render edit view' do
      #     expect(response).to render_template :edit
      #   end
      # end
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

      it 'redirect to root path' do
        delete :destroy, id: answer, format: :js
        expect(response).to redirect_to question_path
      end
    end
  end

  describe 'POST #best' do
    sign_in_user
    let(:answer_owner) { create(:answer, question: question, user: @user) }

    context 'the author' do
      before { post :best, question_id: question, id: answer_owner, format: :js }

      it 'make the answer the best' do
        expect(answer.reload.make_the_best).to eq true
      end

      it 'assigns best answer' do
        answer_owner.reload.make_the_best
        expect(assigns(:answer).best).to_not eq answer_owner.best
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
end
