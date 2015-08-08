FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@email.com" }

  factory :user do
    email
    password '123456789'
    password_confirmation '123456789'
    confirmed_at Time.now
  end

end
