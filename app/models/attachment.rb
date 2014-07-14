require 'file_size_validator'
class Attachment < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  mount_uploader :attachment_file, AttachmentUploader
  validates :attachment_file,
        :file_size => { :maximum => 100.megabytes.to_i}
  validate :check_file_size

  before_save :set_size

  private

  def set_size
    self.file_size = attachment_file.file.size
  end

  def check_file_size
    size = 0
    company = Company.find_by_id(self.company_id)
    company_file_sizes = company.uploads.map(&:file_size)
    company_file_sizes.each { |a| size+=a.to_i }
    self.errors[:file_size_exceeds] = "File size exceeds, you can't attach this file"  if  (size  > 100.megabytes || (size+attachment_file.file.size) > 100.megabytes)
  end
end