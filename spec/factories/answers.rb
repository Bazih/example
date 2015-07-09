FactoryGirl.define do
  sequence(:body) { |n| "Example body #{n}" }

  factory :answer do
    body
    :question
    :user
    best false
  end

  factory :best_answer, class: 'Answer' do
    body
    :question
    :user
    best true
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    :question
    :user
    best false
  end
end
