class AttachmentsController < ApplicationController

  def destroy
    @attach = Attachment.find(params[:id])
    @attach.attachmentable_type == 'Question' ? @result = Question.
        find(@attach.attachmentable) : @result = Answer.find(@attach.attachmentable)
    if current_user.id == @result.user_id
      @attach.destroy ? flash[:notice] = 'Your file was deleted' : flash[:alert] = 'Could not delete the file'
    end
  end
end
