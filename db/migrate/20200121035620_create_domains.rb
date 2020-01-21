class CreateDomains < ActiveRecord::Migration[6.0]
  def change
    create_table :domains, id: :uuid do |t|
      t.string :url
      t.jsonb :archive, null: false, default: '{}'
      t.uuid :node_id
      t.timestamps
    end

    add_index :domains, :url
    add_index :domains, :node_id
    add_index :domains, :created_at
  end
end
