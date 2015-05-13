class AddAttachmentFileToPictures < ActiveRecord::Migration
  def self.up
    change_table :pictures do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :pictures, :file
  end
end
