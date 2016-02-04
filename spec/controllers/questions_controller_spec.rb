require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) {create(:user)}
  let(:question) {create(:question, user: user)}


  describe 'GET #index' do
    let!(:questions) {FactoryGirl.create_list(:question, 3)}
    before {get :index}

    it 'load all questions' do
      # get :index
      expect(assigns(:questions)).to eq questions
    end
    it 'render index template' do
      # get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show'  do

    before {get :show, id: question}

    it 'load all questions' do
      expect(assigns(:question)).to eq question
    end
    it 'render show template' do
      expect(response).to render_template :show
    end

    it 'builds new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end


  end

  describe "GET #new" do

    before do
      login(user)
      get :new
    end


    it 'assigns new Question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new template' do
      expect(response).to render_template :new
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end
  end

  describe 'GET #edit'  do

    before do
      login(user)
      get :edit, id: question
    end

    it 'load all questions' do
      expect(assigns(:question)).to eq question
    end
    it 'render edit template' do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    before {login(user)}
    context 'valid' do
      it 'saves new question in DB' do
        expect { post :create, question: FactoryGirl.attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it "redirect to show" do
        post :create, question: FactoryGirl.attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end


    end

    context 'invalid' do
      it 'does not saves new question in DB' do
        expect { post :create, question: FactoryGirl.attributes_for(:invalid_question) }.to change(Question, :count).by(0)
      end

      it 'render show template' do
        post :create, question: FactoryGirl.attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end


  end

  describe "PATH #update" do

    context 'author change his own question' do
      before {login(user)}
      before {patch :update, id: question, question: {title: 'new title', body: 'new body'}}

      it 'changes question' do

        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to show' do
        expect(response).to redirect_to question
      end
    end

    context 'non-author can not edit question' do
      before {login(create(:user))}
      before {patch :update, id: question, question: {title: 'edited title', body: 'edited body'}}
      it 'does not change question attributes' do
        question.reload
        expect(question.title).to_not eq 'edited title'
        expect(question.body).to_not eq 'edited body'
      end

      it 'renders edit template' do
        expect(response).to render_template :edit
      end

    end

  end

  describe 'DELETE #destroy' do
    before do
      login(user)
      question
    end

    context 'author deletes his own queston' do
      let!(:question){create(:question, user: user)}

      it 'deletes question from DB' do
        expect { delete :destroy, id: question}.to change(Question, :count).by(-1)
      end

      it 'redirect to index'do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end

    end

    context 'non-author can not delete question' do
      before{login(create(:user))}
      before {question}

      it 'does not delete question from DB' do
        expect { delete :destroy, id: question}.to_not change(Question, :count)
      end

    end

  end

end
