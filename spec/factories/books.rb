FactoryGirl.define do
  factory :book do
    title "The Book Title"
    association :publisher, name: "Sextante"
    association :genre, name: "Novel"
    association :author, first_name: "Paulo"

    trait :titleless do
      title nil
    end

    trait :no_author do
      author nil
    end

    trait :no_publisher do
      publisher nil
    end

    trait :no_genre do
      genre nil
    end

  end

  factory :book2, class: Book do
    title "The Other One"
    association :publisher, name: "Letras"
    association :genre, name: "Comic"
    association :author, first_name: "Paulo"
  end

end
