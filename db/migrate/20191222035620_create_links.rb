class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links, id: :uuid do |t|
      t.string :url
      t.jsonb :archive, null: false, default: '{}'
      t.uuid :post_id
      t.timestamps
    end

    add_index :links, :url
    add_index :links, :post_id
    add_index :links, :created_at
  end
end
