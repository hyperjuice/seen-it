class AddFieldsToPosts < ActiveRecord::Migration
  def change
		add_column :posts, :difficulty, :string
   	add_column :posts, :link, :string
  end
end
