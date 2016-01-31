class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:show, :edit, :update, :destroy]

  def new
    @answer = Answer.new
  end

  def edit
    @answer = Answer.find(params[:id])
    respond_to do |format|
          format.json {render json: @answer}
      end
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    respond_to do |format|
      if @answer.save
        if @answer.attachments.first
          attachment_url = @answer.attachments.first.file.url
          attachment_name = @answer.attachments.first.file.identifier
        end
        format.html {redirect_to @question, notice: 'Your answer successfully created'}
        format.js
        format.json do
          response = {answers_count: @question.answers.count, answer: @answer, attachment_url: attachment_url, attachment_name: attachment_name}
          PrivatePub.publish_to "/questions/#{@answer.question_id}/answers", response: response
          render json: response
        end
      else
        format.html {render :new, notice: 'Your answer not created'}
        format.js
        format.json {render json: @answer.errors.full_messages, status: :unprocessable_entity}
      end
    end
  end

  def update
    @answer = Answer.find(params[:id])
    respond_to do |format|
      if current_user.author_of?(@answer)
        if @answer.update(answer_params)
          format.html {redirect_to @answer.question, notice: 'Your answer successfully changed'}
          format.json {render json: @answer}
        else
          format.html {render :edit}
        end
      else
        format.html {render :edit}
      end
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      # redirect_to question_path(@answer.question), notice: 'Your answer successfully deleted'
    else
      redirect_to question_path(@answer.question), notice: 'Answer not deleted'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

end
