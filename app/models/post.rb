class Post < ApplicationRecord
    belongs_to :node
    has_many :links

    def self.import(file)
        require 'csv'
        CSV.foreach(file.path, headers: true) do |row|
            row_hash = row.to_hash
            write_posts(
                row_hash, 
                row_hash['Facebook Id'], 
                'crowdtangle_csv', 
                row_hash['URL'], 
                row_hash['Message'], 
                row_hash['Link'], 
                row_hash['User Name'])
        end
    end

    def self.api_import
        require 'net/https'
        token = ENV['CT_TOCKEN']
        list_id = '1290974'

        uri = URI("https://api.crowdtangle.com/posts?token=#{token}&listIds=#{list_id}&startDate=2019-12-23&sortBy=date")
        request = Net::HTTP.get_response(uri)
        puts rows_hash = JSON.parse(request.body)['result']['posts'] if request.is_a?(Net::HTTPSuccess)
        rows_hash.each do |row_hash|
            write_posts(
                row_hash, 
                row_hash['id'], 
                'crowdtangle_api', 
                row_hash['postUrl'], 
                row_hash['message'], 
                row_hash['link'], 
                row_hash['account']['handle'])
        end
    end

    def self.write_posts(row_hash, facebook_id, source, url, message, link, user_name)
        node = Node.find_or_create_by(
            name: facebook_id, 
            source: source, 
            url: "https://www.facebook.com/#{facebook_id}",
            archive: {
                user_name: user_name,
            }
        )

        post = node.posts.create!(
            archive: row_hash, 
            url: url, 
            title: message, 
            link: link, 
        )

        post.links.create!(
            url: link, 
        ) if link
    end

end
