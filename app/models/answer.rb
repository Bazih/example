class Answer < ActiveRecord::Base
  include Attachmentable
  include Votable
  include Commentable

  default_scope { order('best DESC, created_at ASC') }

  belongs_to :question, touch: true
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true
  validates :body, length: { minimum: 5 }

  after_commit :notify_subscribers, on: :create

  def make_the_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  private

  def notify_subscribers
    AnswerNotificationsJob.perform_later(self)
  end
end
