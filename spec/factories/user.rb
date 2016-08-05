FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user, class: DmUser do
    email
    password 'password'
  end

  factory :user_default, class: DmUser do
    email 'default@default.com'
    password 'password'
  end

  factory :user_admin, class: DmUser do
    email 'user_admin@test.com'
    password 'password'
    admin true
  end
end
