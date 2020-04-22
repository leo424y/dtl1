class CreateBydays < ActiveRecord::Migration[6.0]
  def change
    create_table :bydays, id: :uuid do |t|
      t.string :name
      t.string :data
      t.timestamps
    end

    add_index :bydays, :name
  end
end
