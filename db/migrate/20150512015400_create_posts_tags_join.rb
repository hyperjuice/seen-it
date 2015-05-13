class CreatePostsTagsJoin < ActiveRecord::Migration
  def change
    create_table :posts_tags, id: false do |t|
      t.column :post_id, :integer
      t.column :tag_id, :integer
    end
  end
end
