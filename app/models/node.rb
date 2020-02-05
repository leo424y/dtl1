class Node < ApplicationRecord
  belongs_to :domain
  has_many :posts
  
  scope :order_by_posts_count, -> {
    select("nodes.*, count(posts.id) AS posts_count").
    joins(:posts).                                                   
    group("nodes.id").
    order("posts_count DESC")
  }
end
