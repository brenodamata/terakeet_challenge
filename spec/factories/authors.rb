FactoryGirl.define do
  factory :author do
    first_name "Paulo"
    last_name "Coelho"

    trait :no_first_name do
      first_name nil
    end

    trait :no_last_name do
      last_name nil
    end
  end
end
