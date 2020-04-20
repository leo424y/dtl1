class AddLinkToPages < ActiveRecord::Migration[6.0]
  def change
    add_column :pages, :link, :string
    add_index :pages, :link
  end
end
