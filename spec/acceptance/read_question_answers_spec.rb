require 'rails_helper'

feature 'User can read answers for question' do
  given!(:user) {create(:user)}
  given(:question) {create(:question_with_answers)}

  scenario 'Authentificated user read answers' do
    login(user)
    visit question_path(question)
    # save_and_open_page
    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end

    expect(current_path).to eq question_path(question)
  end


  scenario 'Non-authentificated user read answers' do
    visit question_path(question)
    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
    expect(current_path).to eq question_path(question)
  end

end