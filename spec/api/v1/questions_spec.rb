require 'rails_helper'

RSpec.describe "Qustions API" do
  describe 'GET/index' do
    context 'unauthorized' do
      it 'returns 401 status if request has not access token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token if invalid' do
        get '/api/v1/questions', format: :json, access_token: 123456
        expect(response.status).to eq 401
      end



    end
    context 'authorized' do
      let(:me) {create(:user)}
      let(:access_token) {create(:access_token, resource_owner_id: me.id)}
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }


      before {get '/api/v1/questions', format: :json, access_token: access_token.token}

      it 'returns 200 status' do

        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions/')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("questions/0/answers/0/#{attr}")
          end
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
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token if invalid' do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: 123456
        expect(response.status).to eq 401
      end



    end
    context 'authorized' do
      let(:me) {create(:user)}
      let(:access_token) {create(:access_token, resource_owner_id: me.id)}



      before {get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token}

      it 'returns 200 status' do

        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("question/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question' do
          expect(response.body).to have_json_size(1).at_path('question/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("question/answers/0/#{attr}")
          end
        end
      end

      context 'attachments' #do
      #   it 'included in question' do
      #     expect(response.body).to have_json_size(1).at_path('question/attachments')
      #   end
      #
      # end


    end
  end
end