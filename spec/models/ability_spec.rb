require 'rails_helper'

RSpec.describe Ability do
  subject!(:ability) { Ability.new(user) }

  describe 'for quest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:answer_to_other) { create(:answer, question: question, user: other) }
    let(:user_attach_for_question) do
      create(:attachment, attachmentable: question)
    end
    let(:user_attach_for_answer) do
      create(:attachment, attachmentable: answer)
    end
    let(:voted_up_question) do
      create(question).vote_up(user, 1)
    end
    let(:voted_up_answer) do
      create(answer).vote_up(user, 1)
    end
    let(:voted_down_question) do
      question.vote_down
    end
    let(:voted_down_answer) do
      create(answer).vote_down(user, -1)
    end


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :crud, Question }
    it { should be_able_to :crud, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :crud, question, user: user }
    it { should_not be_able_to :crud, create(:question, user: other), user: user }

    it { should be_able_to :crud, create(:answer, question: question, user: user), user: user }
    it { should_not be_able_to :crud, create(:answer, question: question, user: other), user: user }

    it { should be_able_to :manage, user_attach_for_question }
    it { should_not be_able_to :manage, question }

    it { should be_able_to :manage, user_attach_for_answer }
    it { should_not be_able_to :manage, answer }

    it { should be_able_to :best, answer_to_other }
    it { should_not be_able_to :best, @answer }

    it { should be_able_to :vote_down, @question.vote_down }
    it { should_not be_able_to :vote_up, eval("voted_up_#{resource}") }

    it { should be_able_to :vote_up, eval("voted_down_#{resource}") }
    it { should_not be_able_to :vote_down, eval("voted_down_#{resource}") }

    it { should be_able_to :vote_cancel, eval("voted_up_#{resource}") }
    it { should be_able_to :vote_cancel, eval("voted_down_#{resource}") }
    # Check user can't cancel vote to votable which he haven't vote
    it { should_not be_able_to :vote_cancel, eval(resource) }
  end
end