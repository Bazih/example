class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, except: [:edit, :best, :update, :destroy]
  before_action :load_answer, except: [:create]
  before_action :owner_answer, except: [:create]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = 'Your answer successfully created'
    end
  end

  def best
    @best = @answer.question.answers.find_by(best: true)
    @answer.make_the_best if @answer.user_id == current_user.id
    @best.reload if @best
  end

  def edit
  end

  def update
    @answer.update(answer_params)
    flash[:notice] = 'Your answer successfully update'
    #@question = @answer.question
  end

  def destroy
    @answer.destroy
    flash[:notice] = 'Your answer delete'
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def owner_answer
    redirect_to question_path, notice: 'Access denied' unless @answer.user_id == current_user.id
  end
end