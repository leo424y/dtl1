class Node < ApplicationRecord
  belongs_to :domain
  has_many :posts
end
