FactoryGirl.define do
  factory :answer do
    body 'MyText'
    association :question
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    association :question
  end

end
