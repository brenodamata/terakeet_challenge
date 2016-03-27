FactoryGirl.define do
  factory :book_review do
    association :book, title: "Title"
    trait :rating1 do
      rating 1
    end
    trait :rating2 do
      rating 2
    end
    trait :rating3 do
      rating 3
    end
    trait :rating4 do
      rating 4
    end
    trait :rating5 do
      rating 5
    end
  end
end
