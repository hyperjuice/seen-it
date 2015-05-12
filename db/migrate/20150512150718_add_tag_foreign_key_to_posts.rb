class AddTagForeignKeyToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :tag_id, :integer
  end
end
