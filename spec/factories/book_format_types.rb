FactoryGirl.define do
  factory :pdf, class: BookFormatType do
    name "PDF"
    physical false
  end
  factory :kindle, class: BookFormatType do
    name "Kindle"
    physical false
  end
  factory :paperback, class: BookFormatType do
    name "Paperback"
    physical true
  end
  factory :hardcover, class: BookFormatType do
    name "Hardcover"
    physical true
  end
end
