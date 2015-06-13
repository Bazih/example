class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, except: [:edit, :update, :destroy]
  before_action :load_answer, except: [:create]
  before_action :owner_answer, except: [:create]

   def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:notice_answer] = 'Your answer successfully created'
      redirect_to @question
    else
      flash[:notice_answer] = 'Your answer no created'
      redirect_to @question
    end
  end

  def edit
  end

  def update
    if @answer.update(answer_params)
      flash[:notice_answer] = 'Your answer successfully update'
      redirect_to @answer.question
    else
      flash[:notice_answer] = 'Your answer not update'
      render :edit
    end
  end

  def destroy
    @answer.destroy
    flash[:notice_answer] = 'Your answer delete'
    redirect_to @answer.question
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

  def owner_answer
    redirect_to question_path, notice: 'Access denied' unless @answer.user_id == current_user.id
  end
end