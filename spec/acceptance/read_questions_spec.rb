require 'rails_helper'

feature 'Any user can read questions' do
  questions = FactoryGirl.create_list(:question, 3)
  given!(:user) {create(:user)}

  scenario 'User singed in and read questions' do

    login(user)
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end


  scenario 'Non-singed in user read questions' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end



  end


end