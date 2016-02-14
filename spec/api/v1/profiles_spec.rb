require 'rails_helper'

RSpec.describe "Profiles API" do

  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if request has not access token' do
        get '/api/v1/profiles/me', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token if invalid' do
        get '/api/v1/profiles/me', format: :json, access_token: 123456
        expect(response.status).to eq 401
      end


    end


    context 'authorized' do
      let(:me) {create(:user)}
      let(:access_token) {create(:access_token, resource_owner_id: me.id)}

      before {get '/api/v1/profiles/me', format: :json, access_token: access_token.token}

      it 'returns 200 status' do

        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|

        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr).to_json).at_path(attr)
        end


      end

      %w(password encrypted_password).each do |attr|

        it "does not contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end


      end




    end

  end

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if request has not access token' do
        get '/api/v1/profiles', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token if invalid' do
        get '/api/v1/profiles', format: :json, access_token: 123456
        expect(response.status).to eq 401
      end


    end


    context 'authorized' do
      let(:me) {create(:user)}
      let(:access_token) {create(:access_token, resource_owner_id: me.id)}
      let!(:users) { create_list(:user, 2) }
      let(:user) {users.first}


      before {get '/api/v1/profiles', format: :json, access_token: access_token.token}

      it 'returns 200 status' do

        expect(response).to be_success
      end

      it 'returns list of users' do
        expect(response.body).to have_json_size(2).at_path('profiles/')
      end

      %w(id email created_at updated_at admin).each do |attr|

        it "contains #{attr}" do
          expect(response.body).to be_json_eql(user.send(attr).to_json).at_path("profiles/0/#{attr}")
        end


      end

      %w(password encrypted_password).each do |attr|

        it "does not contains #{attr}" do
          expect(response.body).to_not have_json_path("profiles/0/#{attr}")
        end

      end

      it 'not contains ME' do
        expect(response.body).to_not include_json(me.to_json).at_path('profiles/')
      end



    end

  end

end