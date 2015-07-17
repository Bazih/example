class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment, only: [:destroy]

  def destroy
    if current_user.id == @attachment.attachmentable.user_id
      @attachment.destroy ? flash[:notice] = 'Your file was deleted' : flash[:alert] = 'Could not delete the file'
    end
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end
