require 'rails_helper'

feature 'Authentificated user can write answer for question' do

  given!(:user) {create(:user)}
  given!(:questions) {create_list(:question_with_answers, 3)}
  given(:question) {questions.last}


  scenario 'Authentificated user write answer' do
    login(user)
    visit questions_path
    click_on question.title
    fill_in 'Your answer', with: 'My answer'
    click_on 'Send answer'
    # save_and_open_page
    expect(page).to have_content 'Your answer successfully created'
    expect(page).to have_content 'My answer'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authentificated user tries to write answer' do
    visit questions_path
    click_on question.title
    fill_in 'Your answer', with: 'My answer'
    click_on 'Send answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end

end