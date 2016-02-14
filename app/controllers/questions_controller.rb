class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  authorize_resource

  def index
    # authorize! :index, Question
    @questions = Question.all
  end

  def show
    # authorize! :show, @question
    @question = Question.find(params[:id])
    @answer = Answer.new
    @answer.attachments.build
    respond_to do |format|
      format.html
      format.json  {render json: @question}
    end
  end

  def new
    # authorize! :create, Question
    @question = Question.new
    @question.attachments.build
  end

  def edit
    authorize! :update, @question
    @question = Question.find(params[:id])
  end

  def create
    # authorize! :create, Question
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
    # authorize! :update, @question
    respond_to do |format|
      @question = Question.find(params[:id])
      if @question.update(question_params)
        format.html {redirect_to @question, notice: 'Your question successfully saved'}
        format.json {render json: @question}
      else
        format.html {render :new}
      end
    end
  end

  def destroy
    # authorize! :destroy, @question
    @question.destroy
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
