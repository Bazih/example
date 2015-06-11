FactoryGirl.define do
  sequence(:body) { |n| "Example body #{n}" }

  factory :answer do
    body
    :question
    :user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    :question
    :user
  end

end
