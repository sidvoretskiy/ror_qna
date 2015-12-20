FactoryGirl.define do

  sequence :title do |n|
    "My_question #{n}"
  end
  sequence :body do |n|
    "#{n} question body"
  end

  factory :question do
    title
    body
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end