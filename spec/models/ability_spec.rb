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
    let(:question_other) { create(:question, user: other) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:answer_other) { create(:answer, question: question, user: other) }

    let(:user_attach_for_question) { create(:attachment, attachmentable: question) }
    let(:user_attach_for_answer) { create(:attachment, attachmentable: answer) }

    let(:voted_up_question) { question.make_vote(user, 1) }
    let(:voted_up_question_other) { question.make_vote(other, 1) }
    let(:voted_down_question) { question.make_vote(user, -1) }
    let(:voted_down_question_other) { question_other.make_vote(other, -1) }
    let(:up_vote_question) { create(:vote_up, user: user, votable: question_other) }
    let(:down_vote_question) { create(:vote_down, user: user, votable: question_other) }

    let(:voted_up_answer) { answer.make_vote(user, 1) }
    let(:voted_up_answer_other) { answer_other.make_vote(other, 1) }
    let(:voted_down_answer) { answer.make_vote(user, -1) }
    let(:voted_down_answer_other) { answer_other.make_vote(other, -1) }
    let(:up_vote_answer) { create(:vote_up, user: user, votable: answer_other) }
    let(:down_vote_answer) { create(:vote_down, user: user, votable: answer_other) }

    let(:subscription) { build(:subscription) }
    let(:subscription_to_subscribed_question) do
      build(:subscription, question: create(:subscription, user: user).question)
    end

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :crud, Question }
    it { should be_able_to :crud, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :crud, question, user: user }
    it { should_not be_able_to :crud, question_other, user: user }

    it { should be_able_to :crud, answer, user: user }
    it { should_not be_able_to :crud, answer_other, user: user }

    it { should be_able_to :manage, user_attach_for_question }
    it { should_not be_able_to :manage, question }

    it { should be_able_to :manage, user_attach_for_answer }
    it { should_not be_able_to :manage, answer }

    it { should be_able_to :best, answer_other }
    it { should_not be_able_to :best, @answer }


    it 'should be able to vote_up Question' do
      voted_up_question_other
      should be_able_to :vote_up, question_other
    end
    it 'should_not be able to vote_up Question' do
      voted_up_question
      should_not be_able_to :vote_up, question
    end
    it 'should be able to vote_down Question' do
      voted_down_question_other
      should be_able_to :vote_down, question_other
    end
    it 'should not be able to vote_down Question' do
      voted_down_question
      should_not be_able_to :vote_down, question
    end
    it 'up_vote should be able to vote_cancel other Question' do
      up_vote_question
      should be_able_to :vote_cancel, question_other
    end
    it 'down_vote should be able to vote_cancel other Question' do
      down_vote_question
      should be_able_to :vote_cancel, question_other
    end
    it 'up_vote should not be able to vote_cancel Question' do
      up_vote_question
      should_not be_able_to :vote_cancel, question
    end
    it 'down_vote should not be able to vote_cancel Question' do
      down_vote_question
      should_not be_able_to :vote_cancel, question
    end


    it 'should be able to vote_up Answer' do
      voted_up_answer_other
      should be_able_to :vote_up, answer_other
    end
    it 'should_not be able to vote_up Answer' do
      voted_up_answer
      should_not be_able_to :vote_up, answer
    end
    it 'should be able to vote_down Answer' do
      voted_down_answer_other
      should be_able_to :vote_down, answer_other
    end
    it 'should not be able to vote_down Answer' do
      voted_down_answer
      should_not be_able_to :vote_down, answer
    end
    it 'up_vote should be able to vote_cancel other Answer' do
      up_vote_answer
      should be_able_to :vote_cancel, answer_other
    end
    it 'down_vote should be able to vote_cancel other Answer' do
      down_vote_answer
      should be_able_to :vote_cancel, answer_other
    end
    it 'up_vote should not be able to vote_cancel Answer' do
      up_vote_answer
      should_not be_able_to :vote_cancel, answer
    end
    it 'down_vote should not be able to vote_cancel Answer' do
      down_vote_answer
      should_not be_able_to :vote_cancel, answer
    end

    it { should be_able_to :me, User }

    it { should be_able_to :create, subscription }
    it { should_not be_able_to :create, subscription_to_subscribed_question }
  end
end