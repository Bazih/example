require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id}
  it { should validate_length_of(:title).is_at_least(2).is_at_most(150) }
  it { should validate_length_of(:body).is_at_least(5).is_at_most(400) }
  it { should validate_uniqueness_of(:title)}

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }

  describe '#<best_answer>' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answers) { create_list(:answer, 5, question: question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    it 'should find the best answer' do
      question.answers.update_all(best: false)

      answer.update(best: true)

      expect(question.best_answer).to eq answer
    end
  end


end
