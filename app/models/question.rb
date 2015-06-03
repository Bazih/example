class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, length: { minimum: 2, maximum: 150 } 
  validates :body, length: { minimum: 5, maximum: 400 }
  validates :title, uniqueness: true
end
