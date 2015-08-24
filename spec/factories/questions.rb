FactoryGirl.define do
  sequence(:title) { |n| "New title #{n}" }

  factory :question do
    title
    body 'MyText'
    user

    trait :old do
      created_at { 1.day.ago }
    end

    factory :old_question, traits: [:old]
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user
  end
end
