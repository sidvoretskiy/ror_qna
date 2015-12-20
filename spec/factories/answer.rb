FactoryGirl.define do
  factory :answer do
    body 'answer body'
  end

  factory :invalid_answer, class: 'Answer' do
    title nil
  end
end