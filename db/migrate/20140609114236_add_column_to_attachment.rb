class AddColumnToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :classified, :string
  end
end
