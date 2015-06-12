class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :answers, allow_destroy: true

  validates :title, :body, :user_id, presence: true
  validates :title, length: { minimum: 2, maximum: 150 }
  validates :body, length: { minimum: 5, maximum: 400 }
  validates :title, uniqueness: true

end
