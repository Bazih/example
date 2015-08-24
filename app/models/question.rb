class Question < ActiveRecord::Base
  include Attachmentable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id, presence: true
  validates :title, length: { minimum: 2, maximum: 150 }
  validates :body, length: { minimum: 5, maximum: 400 }
  validates :title, uniqueness: true

  scope :yesterday, -> { where(created_at: Time.current.yesterday.all_day) }

  def best_answer
    answers.where(best: true).take
  end

  after_commit :subscribe_author, on: :create

  private

  def subscribe_author
    Subscription.create(question: self, user: user)
  end
end
