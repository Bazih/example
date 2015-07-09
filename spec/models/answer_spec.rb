require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:question_id) }
  it { should validate_presence_of(:user_id)}
  it { should validate_length_of(:body).is_at_least(5) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:attachments) }

  it { should accept_nested_attributes_for :attachments }

  describe '#make_the_best' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    it 'should make the answer the best' do
      question.answers.update_all(best: false)

      answer.make_the_best

      expect(answer.best).to eq true
    end

    it 'should to make the rest of the answers are not the best' do
      other_answer = create(:answer, question: question, user: user)
      question.answers.update_all(best: false)

      answer.make_the_best
      other_answer.make_the_best
      answer.reload
      other_answer.reload

      expect(other_answer.best).to eq true
      expect(answer.best).to eq false
    end
  end
end
