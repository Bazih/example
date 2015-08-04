class QuestionsController < ApplicationController
  include Voting

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :gon_current_user, only: [:index, :show]
  before_action :owner_question, only: [:edit, :update, :destroy]
  before_action :build_answer, only: :show

  respond_to :js, only: :update

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
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      PrivatePub.publish_to "/questions", question: @question.to_json
      respond_with @question
    else
      respond_with @question
    end
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

  def owner_question
    redirect_to root_url, notice: 'Access denied' unless @question.user_id == current_user.id
  end
end
