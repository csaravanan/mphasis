class ArtifactAnswersController < ApplicationController

  before_filter :company_module_access_check
  
  #List attachements for particular artifacts
  def list_attachments
    @artifact_answer = ArtifactAnswer.find(params[:id])
    @attachments = @artifact_answer.attachments
    render layout: false
  end

 # Create attachment for artifact
  def create_attachment
    @artifact_answer = ArtifactAnswer.find(params[:id])
    if params[:file]
      params[:file].each do |attachment|
        @artifact_answer.attachments.create(attachment_file: attachment, :company_id => current_company.id)
        @attachment_error = @artifact_answer.attachments.last.errors[:"file_size_exceeds"][0] if @artifact_answer.attachments.last.errors.present?
      end
    end
    @attachments = @artifact_answer.attachments
  end

 # remove attached artifacts
  def remove_attachment
    attachment = Attachment.find(params[:id])
    attachment.delete
  end

  # List comment for artifacts
  def list_comment
    @artifact_answer = ArtifactAnswer.find(params[:id])
    render layout: false
  end

  # update Comment for artifacts
  def update_comment
    @artifact_answer = ArtifactAnswer.find(params[:artifact_answer][:id])
    @artifact_answer.update_attributes(comment_params)
  end

  private
  # Strong Parameters for comment to artifacts
  def comment_params
    params.require(:artifact_answer).permit(:id, comment_attributes: [:comment, :id])
  end
end