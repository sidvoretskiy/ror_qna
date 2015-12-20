require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) {FactoryGirl.create(:question)}
  let(:answer) {FactoryGirl.create(:answer)}


  describe "GET #new" do
    before {get :new, question_id: question}

    it 'assigns new Answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns Answer for current Question' do
      expect(assigns(:answer).question).to eq @question
    end

    it 'render new template' do
      expect(response).to render_template :new
    end

  end



  describe 'POST #create' do
    context 'valid' do

      it 'saves new answer' do
        expect { post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer)}.to change(Answer, :count).by(1)
      end

      it 'answer assign to question' do

        post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer)
        question.reload
        # expect(answer.question).to eq question
        expect { post :create, question_id: question, answer: FactoryGirl.attributes_for(:invalid_answer)}.to change(question.answers, :count).by(1)
        # expect(response).to change(question.answers, :count).by(1)
      end

      it 'redirect to question' do
        post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns(:question))
      end

    end

    context 'invalid' do

      it 'does not saves new answer' do
        expect { post :create, question_id: question, answer: FactoryGirl.attributes_for(:invalid_answer)}.to change(Answer, :count).by(0)
      end

      it 'redirect to new answer' do
        post :create, question_id: question, answer: FactoryGirl.attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end

    end



  end

end
