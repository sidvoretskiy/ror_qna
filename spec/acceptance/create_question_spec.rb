require 'rails_helper'

feature 'Create question', %q{
        In order to get answer from community
        As an authenticated user
        I want to be able to ask question} do

  # background do
  #   выполняется до теста
  # end


  
  given!(:user) {create(:user)}
  scenario  'Authentificated user create question' do

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'text text'
    click_on 'Create'
    expect(page).to have_content 'Your question successfully created'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text'

  end


  scenario 'Non-authentificated user tries to create user' do

    visit questions_path
    click_on 'Ask question'
    # save_and_open_page


    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path


  end

end