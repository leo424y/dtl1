class Post < ApplicationRecord
    belongs_to :node

    def self.import(file)
        require 'csv'
        CSV.foreach(file.path, headers: true) do |row|
            row_hash = row.to_hash
            node = Node.find_or_create_by(name: row_hash['Facebook Id'], source: 'facebook', url: "https://www.facebook.com/#{row_hash['Facebook Id']}" )
            node.posts.create!(archive: row_hash, url: row_hash['URL'], title: row_hash['Message'])
        end
    end
end
