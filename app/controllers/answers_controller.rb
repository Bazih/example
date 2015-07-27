class AnswersController < ApplicationController
  include Voting

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:create]#except: [:edit, :best, :update, :destroy, :vote_up, :vote_down, :vote_cancel]
  before_action :load_answer, except: [:create]
  before_action :owner_answer, except: [:create, :best, :vote_up, :vote_down, :vote_cancel]

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    respond_to do |format|
      if @answer.save
        flash[:notice] = 'Your answer successfully created'
        format.js do
          PrivatePub.publish_to "/questions/#{@question.id}/answers", response: {
                                    answer: @answer,
                                    attachments: @answer.attachments,
                                    }.to_json
        end
      else
        format.js
      end
    end
  end

  def best
    @best = @answer.question.best_answer
    @answer.make_the_best if @answer.question.user_id == current_user.id
    @best.reload if @best
  end

  def update
    @answer.update(answer_params)
    flash[:notice] = 'Your answer successfully update'
  end

  def destroy
    @answer.destroy
    flash[:notice] = 'Your answer delete'
  end

  private

  def load_question
    #binding.pry
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