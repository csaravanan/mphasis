class AddFilesizeToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :file_size, :string
    add_column :attachments, :company_id, :integer
  end
end
