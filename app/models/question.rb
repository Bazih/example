class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachmentable

  validates :title, :body, :user_id, presence: true
  validates :title, length: { minimum: 2, maximum: 150 }
  validates :body, length: { minimum: 5, maximum: 400 }
  validates :title, uniqueness: true

  accepts_nested_attributes_for :attachments, :reject_if => :all_blank, :allow_destroy => true

  def best_answer
    answers.where(best: true).take
  end
end
