require 'rails_helper'

describe 'Questions API' do
  let(:access_token) { create(:access_token) }

  describe 'GET #index' do
    let(:url) { '/api/v1/questions' }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get url, format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('questions/0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:question) { create(:question) }
    let(:url) { api_v1_question_path(question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:attach) { create(:attachment, attachmentable: question) }
      let!(:comment) { create(:comment, commentable: question, commentable_type: 'Question') }

      before { get url, format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json)
                                       .at_path("question/#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('question/comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json)
                                         .at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attach.file.url.to_json)
                                       .at_path('question/attachments/0/url')
        end
      end
    end
  end

  describe 'POST #create' do
    let(:url) { api_v1_questions_path }
    let(:current_user) { User.find(access_token.resource_owner_id) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'with valid attributes' do
        it 'returns status 201' do
          post url, format: :json, access_token: access_token.token,
               question: attributes_for(:question)
          expect(response).to have_http_status :created
        end

        it 'saves question in database' do
          expect { post url, format: :json, access_token: access_token.token,
                        question: attributes_for(:question)
          }.to change(Question, :count).by(1)
        end

        it 'assigns created question to current user' do
          expect { post url, format: :json, access_token: access_token.token,
                        question: attributes_for(:question)
          }.to change(current_user.questions, :count).by(1)
        end
      end

      context 'witn invalid attributes' do
        it 'returns status 422' do
          post url, format: :json, access_token: access_token.token,
               question: attributes_for(:invalid_question)
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'does not save question in database' do
          expect { post url, format: :json, access_token: access_token.token,
                        question: attributes_for(:invalid_question)
          }.to_not change(Question, :count)
        end
      end
    end
  end

  def do_request(path, options = {})
    get path, { format: :json }.merge(options)
  end
end
