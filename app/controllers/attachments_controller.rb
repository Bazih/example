class AttachmentsController < ApplicationController

  def destroy
    @attach = Attachment.find(params[:id])
    @attach.attachmentable_type == 'Question' ? @result = Question.
        find(@attach.attachmentable_id) : @result = Answer.find(@attach.attachmentable_id)
    if current_user.id == @result.user_id
      @attach.destroy ? flash[:notice] = 'Your file was deleted' : flash[:alert] = 'Could not delete the file'
    end
  end
end
