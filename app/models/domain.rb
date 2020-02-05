class Domain < ApplicationRecord
    has_many :nodes
    scope :order_by_nodes_count, -> {
        select("domains.*, count(nodes.id) AS nodes_count").
        joins(:nodes).                                                   
        group("domains.id").
        order("nodes_count DESC")
      }
end