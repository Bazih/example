FactoryGirl.define do
  sequence(:title) { |n| "New title #{n}" }

  factory :question do
    title
    body 'MyText'
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end

end
