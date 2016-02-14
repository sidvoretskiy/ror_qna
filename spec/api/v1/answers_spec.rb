require 'rails_helper'

RSpec.describe "Answers API" do
  describe 'GET/index' do
    let(:question) {create(:question)}
    let!(:answers) {create_list(:answer, 2, question: question) }
    let(:answer){answers.first}
    context 'unauthorized' do
      it 'returns 401 status if request has not access token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token if invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: 123456
        expect(response.status).to eq 401
      end



    end
    context 'authorized' do
      let(:me) {create(:user)}
      let(:access_token) {create(:access_token, resource_owner_id: me.id)}

      before {get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token}

      it 'returns 200 status' do

        expect(response).to be_success
      end


      it 'return list of answers' do
        expect(response.body).to have_json_size(2).at_path('answers/')
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

  end

  describe 'GET/show' do
    let(:question) {create(:question)}
    # let!(:attachment) {create(:attachment, question: question)}
    let!(:answer) { create(:answer, question: question) }
    context 'unauthorized' do
      it 'returns 401 status if request has not access token' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token if invalid' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: 123456
        expect(response.status).to eq 401
      end



    end
    context 'authorized' do
      let(:me) {create(:user)}
      let(:access_token) {create(:access_token, resource_owner_id: me.id)}



      before {get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: access_token.token}

      it 'returns 200 status' do

        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("answer/#{attr}")
        end
      end


      it "contains attachments"


    end
  end
end