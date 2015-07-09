class Answer < ActiveRecord::Base
  default_scope { order('best DESC') }

  belongs_to :question
  belongs_to :user
  has_many   :attachments, as: :attachmentable

  validates :body, :question_id, :user_id, presence: true
  validates :body, length: { minimum: 5 }

  accepts_nested_attributes_for :attachments

  def make_the_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
