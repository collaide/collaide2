FactoryGirl.define do
  factory :user do
    name 'Test'
    email 'test@collaide.com'
    password 'grimpe'
    password_confirmation 'grimpe'
  end
end