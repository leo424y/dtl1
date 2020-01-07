# Based on Facebook, 'url' means postUrl, 'link' is the main Link the post shared, 'score' is calcualated by CrowdTangle,
class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts, id: :uuid do |t|
      t.string :url
      t.string :link
      t.string :title
      t.string :date
      t.string :updated
      t.jsonb :archive, null: false, default: '{}'
      t.uuid :node_id
      t.decimal :score
      t.timestamps
    end

    add_index :posts, :url
    add_index :posts, :link
    add_index :posts, :date
    add_index :posts, :updated
    add_index :posts, :node_id
    add_index :posts, :score
    add_index :posts, :created_at
  end
end
