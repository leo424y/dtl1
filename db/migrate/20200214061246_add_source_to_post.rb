class AddSourceToPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :source, :string
    add_index :posts, :source
  end
end
