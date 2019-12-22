class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts, id: :uuid do |t|
      t.string :url
      t.string :link
      t.string :title
      t.jsonb :archive, null: false, default: '{}'
      t.uuid :node_id

      t.timestamps
    end

    add_index :posts, :url
    add_index :posts, :link
    add_index :posts, :title
    add_index :posts, :node_id
    add_index :posts, :created_at
  end
end
