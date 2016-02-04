require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) {create(:user)}
  let(:question) {FactoryGirl.create(:question)}
  let(:answer) {FactoryGirl.create(:answer)}


  describe "GET #new" do
    before {login(user)}
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
    before {login(user)}
    context 'valid' do

      it 'saves new answer' do
        expect { post :create, question_id: question, user_id:user, answer: FactoryGirl.attributes_for(:answer), format: :js}.to change(Answer, :count).by(1)
      end

      it 'answer assign to question' do

        post :create, question_id: question, user_id: user, format: :js, answer: FactoryGirl.attributes_for(:answer)
        # question.reload
        # expect(answer.question).to eq question
        expect { post :create, question_id: question, user_id: user, format: :js, answer: FactoryGirl.attributes_for(:answer)}.to change(question.answers, :count).by(1)
        # expect(response).to change(question.answers, :count).by(1)
      end

      it 'user assign to answer' do

        post :create, question_id: question, user_id: user, format: :js, answer: FactoryGirl.attributes_for(:answer)
        # question.reload
        # expect(answer.question).to eq question
        expect { post :create, question_id: question, user_id: user, format: :js, answer: FactoryGirl.attributes_for(:answer)}.to change(user.answers, :count).by(1)
        # expect(response).to change(question.answers, :count).by(1)
      end


      # it 'redirect to question' do
      #   post :create, question_id: question, format: :js, answer: FactoryGirl.attributes_for(:answer)
      #   expect(response).to redirect_to question_path(assigns(:question))
      # end


    end

    context 'invalid' do

      it 'does not saves new answer' do
        expect { post :create, question_id: question, user_id: user, format: :js, answer: FactoryGirl.attributes_for(:invalid_answer)}.to change(Answer, :count).by(0)
      end

      # it 'redirect to new answer' do
      #   post :create, question_id: question, user_id: user, answer: FactoryGirl.attributes_for(:invalid_answer), format: :js
      #   expect(response).to render_template :new
      # end

    end



  end

  describe 'DELETE #destroy' do
    before do
      login(user)
      question
    end

    context 'author deletes his own answer' do
      let!(:question){create(:question, user: user)}
      let!(:answer){create(:answer, user: user, question: question)}

      it 'deletes answer from DB' do
        expect { delete :destroy, id: answer, format: :js}.to change(Answer, :count).by(-1)
      end

      it 'redirect to question'do
        delete :destroy, id: answer, format: :js
        # expect(response).to redirect_to question_path(question)
      end

    end

    context 'non-author can not delete answer' do
      let!(:answer){create(:answer, user: create(:user), question: question)}

      it 'does not delete answer from DB' do
        expect { delete :destroy, id: answer,  format: :js}.to_not change(Answer, :count)
      end

    end

  end

  describe "PATH #update" do

    let!(:answer){create(:answer, user: user, question: question)}
    context 'author edit his own answer' do
      before {login(user)}
      before {patch :update, id: answer, answer: {body: 'new body'}}

      it 'changes answer' do

        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to question' do
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'non-author can not edit answer' do
      before {login(create(:user))}
      before {patch :update, id: answer, answer: {body: 'edited body'}}
      it 'does not change question attributes' do
        answer.reload
        expect(answer.body).to_not eq 'edited body'
      end

      # it 'renders edit template' do
      #   expect(response).to render_template answer
      # end

    end

  end

end
