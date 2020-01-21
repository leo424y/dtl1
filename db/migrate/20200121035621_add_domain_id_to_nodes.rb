class AddDomainIdToNodes < ActiveRecord::Migration[6.0]
  def change
    add_column :nodes, :domain_id, :uuid
    add_index :nodes, :domain_id
  end
end
