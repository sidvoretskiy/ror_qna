FactoryGirl.define do

  # sequence :body do |n|
  #   "answer body #{n}"
  # end

  factory :answer do
    sequence :body do |n|
      "My_answer #{n}"
    end
    user
    question
  end

  factory :invalid_answer, class: 'Answer' do
    title nil
  end
end