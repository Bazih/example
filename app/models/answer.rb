class Answer < ActiveRecord::Base
  include Attachmentable

  default_scope { order('best DESC') }

  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true
  validates :body, length: { minimum: 5 }

  def make_the_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
