FactoryGirl.define do
  sequence(:body) { |n| "Example body #{n}" }

  factory :answer do
    body
    association :question
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    association :question
  end

end
