require 'rails_helper'
feature 'Edit question' do

  given!(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}


  scenario 'Author can edit question' do
    login(user)
    visit questions_path
    click_on 'Edit'
    fill_in 'Title', with: 'Edited question title'
    fill_in 'Text', with: 'Edited text'
    click_on 'Save'
    expect(page).to have_content 'Your question successfully saved'
    expect(page).to have_content 'Edited question title'
    expect(page).to have_content 'Edited text'
    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content question.title
  end

  scenario 'Non-author can not edit question' do
    login(create(:user))
    visit questions_path
    expect(page).to_not have_link 'Edit'
  end
  scenario 'Non-authenticated user can not Edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end
end