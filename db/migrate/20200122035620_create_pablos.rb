class CreatePablos < ActiveRecord::Migration[6.0]
  def change
    create_table :pablos, id: :uuid do |t|
      t.string :word
      t.jsonb :archive, null: false, default: '{}'
      t.timestamps
    end
    
    add_index :pablos, :word
  end
end
