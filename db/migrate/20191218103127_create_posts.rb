class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts, id: :uuid do |t|
      t.string :url
      t.jsonb :archive
      t.uuid :node_id

      t.timestamps
    end

    add_index :posts, :node_id
    add_index :posts, :created_at
  end
end
