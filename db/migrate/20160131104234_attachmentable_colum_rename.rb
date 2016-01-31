class AttachmentableColumRename < ActiveRecord::Migration
  def change
    rename_column :attachments, :attachemntable_type, :attachmentable_type
  end
end
