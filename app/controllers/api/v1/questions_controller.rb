class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: :show
  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def load_question
    @question = Question.find(params[:id])
  end
end