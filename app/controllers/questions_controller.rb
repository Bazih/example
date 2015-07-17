class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :owner_question, only: [:edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.answers.build
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Question successfully created!'
    else
      flash.now[:error] = 'Error, check the name or text of the question'
      render :new
    end
  end

  def update
    @question.update(question_params)
    flash[:notice] = 'Question successfully updated!'
  end

  def destroy
    @question.destroy
    flash[:notice] = 'Your question was successfully deleted'
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def owner_question
    redirect_to root_url, notice: 'Access denied' unless @question.user_id == current_user.id
  end

end