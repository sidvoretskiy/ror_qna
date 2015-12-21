require 'rails_helper'

RSpec.describe User do
  it {should validate_presence_of :email}
  it {should validate_presence_of :password}
  it {should have_many(:questions)}
  it {should have_many(:answers)}

  describe '#author_of?' do
    let!(:user){create(:user)}
    it 'return true if user is author of object' do
      object = create(:question, user: user)
      # expect(user.authir_if?(object)).to be_truthy
      expect(user).to be_author_of(object)
    end

    it 'return false if user is not author of object' do
      object = create(:question)
      # expect(user.authir_if?(object)).to be_truthy
      expect(user).to_not be_author_of(object)
    end
  end
end