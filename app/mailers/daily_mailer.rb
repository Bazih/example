class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.yesterday
    mail to: user.email, subject: 'Questions asked yesterday'
  end
end
