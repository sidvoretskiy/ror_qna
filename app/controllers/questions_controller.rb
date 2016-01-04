class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
    respond_to do |format|
      format.html
      format.json  {render json: @question}
    end
  end

  def new
    @question = Question.new
  end

  def edit
    @question = Question.find(params[:id])
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      response = {question: @question}
      PrivatePub.publish_to "/questions", response: response
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new, notice: 'Your question was not created'
    end
  end

  def update
    respond_to do |format|
      if current_user.author_of?(@question)
        @question = Question.find(params[:id])


        if @question.update(question_params)
          format.html {redirect_to @question, notice: 'Your question successfully saved'}
          format.json {render json: @question}
        else
          format.html {render :new}
        end
      else
        format.html {render :edit}
      end
    end
  end

  def destroy
    @question.destroy if current_user.author_of?(@question)
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
