class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:show, :edit, :update, :destroy]

  def new
    @answer = Answer.new
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      # redirect_to @question, notice: 'Your answer successfully created'
    else
      render :new, notice: 'Your answer not created'
    end

  end

  def update
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      if @answer.update(answer_params)
        redirect_to @answer.question, notice: 'Your answer successfully changed'
      else
        render :edit
      end
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Your answer successfully deleted'
    else
      redirect_to question_path(@answer.question), notice: 'Answer not deleted'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

end
