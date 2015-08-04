class AnswersController < ApplicationController
  include Voting

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:create]
  before_action :load_answer, except: [:create]
  before_action :owner_answer, except: [:create, :best, :vote_up, :vote_down, :vote_cancel]

  respond_to :js
  respond_to :json, only: :create

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user

    if @answer.save
      render json: {
                 answer: @answer,
                 attachments: @answer.attachments,
             }
      PrivatePub.publish_to "/questions/#{@question.id}/answers", response: {
                                    answer: @answer,
                                    attachments: @answer.attachments,
                                    }.to_json
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def best
    @best = @answer.question.best_answer
    @answer.make_the_best if @answer.question.user_id == current_user.id
    @best.reload if @best
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def owner_answer
    redirect_to question_path, notice: 'Access denied' unless @answer.user_id == current_user.id
  end
end