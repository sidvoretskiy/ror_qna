require 'rails_helper'

feature 'Add files to answer' do
  given(:user) {create(:user)}
  given(:question) {create(:question)}

  background do
    login(user)
    visit new_question_path
  end

  scenario 'User adds file when answers question' do
    fill_in 'Your answer', with: 'My answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link "spec_helper.rb"
    end

  end


end