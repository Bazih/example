class QuestionsController < ApplicationController
  include Voting

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :gon_current_user, only: [:index, :show]
  before_action :owner_question, only: [:edit, :update, :destroy]
  before_action :build_answer, only: :show
  after_action :publich_create, only: :create

  respond_to :js, only: :update

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with (@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def gon_current_user
    gon.current_user = user_signed_in? && current_user.id
    gon.question_author = @question.user_id if @question
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def publich_create
    PrivatePub.publish_to "/questions", question: @question.to_json if @question.valid?
  end

  def owner_question
    redirect_to root_url, notice: 'Access denied' unless @question.user_id == current_user.id
  end
end
