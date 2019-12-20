class Post < ApplicationRecord
    belongs_to :node

    def self.import(file)
        require 'csv'
        CSV.foreach(file.path, headers: true) do |row|
            row_hash = row.to_hash
            Node.last.posts.create!(archive: row_hash, url: row.to_hash['URL'], title: row_hash['Message'])
        end
    end
end
