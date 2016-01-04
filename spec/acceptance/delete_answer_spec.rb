require 'rails_helper'

feature 'Delete answer' do

  given!(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given!(:answers) {create_list(:answer, 3, user: user, question: question)}

  scenario 'Author can delete answer' , js: true do
    login(user)
    visit question_path(question)
    within ('#answer_'+ question.answers.first.id.to_s) do
      @answer = question.answers.first.body
      click_on 'Delete answer'
    end

    expect(current_path).to eq question_path(question)
    # save_and_open_page
    # expect(page).to have_content 'Your answer successfully deleted'
    expect(page).to_not have_content @answer
  end

  scenario 'Non-author can not delete answer' do
    login(create(:user))
    visit question_path(question)
    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Non-authenticated user can not delete answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete answer'
  end

end