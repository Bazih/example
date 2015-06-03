require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_least(2).is_at_most(150) }
  it { should validate_length_of(:body).is_at_least(5).is_at_most(400) }
  it { should validate_uniqueness_of(:title)}
  it { should have_many(:answers).dependent(:destroy) }
end
