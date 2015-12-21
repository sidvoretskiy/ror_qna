require 'rails_helper'
feature 'Edit answer' do

  given!(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given!(:answers) {create_list(:answer, 3, user: user, question: question)}

  scenario 'Author can edit answer' do
    login(user)
    visit question_path(question)

    within ('#answer_'+ question.answers.first.id.to_s) do
      @answer = question.answers.first.body
      click_on 'Edit answer'
    end
    fill_in 'Your answer', with: 'My edited answer'
    click_on 'Save answer'
    expect(current_path).to eq question_path(question)
    # save_and_open_page
    expect(page).to have_content 'Your answer successfully changed'
    expect(question.answers.first.body).to eq 'My edited answer'

  end

  scenario 'Non-author can not edit answer' do
    login(create(:user))
    visit question_path(question)
    expect(page).to_not have_link 'Edit answer'
  end

  scenario 'Non-authenticated user can not edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit answer'
  end
end