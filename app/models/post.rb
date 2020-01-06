class Post < ApplicationRecord
    belongs_to :node
    has_many :links

    def self.search(search)
        if search
          where('link LIKE :search' ,search: "%#{search}%")
        else
          limit(50)
        end
    end

    def self.import(file)
        require 'csv'
        CSV.foreach(file.path, headers: true) do |row|
            row_hash = row.to_hash
            write_posts(
                row_hash, 
                row_hash['Facebook Id'], 
                'facebook', 
                row_hash['URL'], 
                row_hash['Message'], 
                row_hash['Link'], 
                row_hash['User Name'],
                row_hash['Created'],
                row_hash['Created'],
                row_hash['Description'],
                row_hash['Overperforming Score'],
                'csv'
            )
        end
    end

    def self.api_import
        require 'net/https'
        token = ENV['CT_TOCKEN']
        list_ids = ['1290974','1290972']
        list_ids.each do |list_id|
            uri = URI("https://api.crowdtangle.com/posts?token=#{token}&listIds=#{list_id}&startDate=#{Date.today.strftime("%Y-%m-%d")}&sortBy=date&count=100")
            request = Net::HTTP.get_response(uri)
            puts rows_hash = JSON.parse(request.body)['result']['posts'] if request.is_a?(Net::HTTPSuccess)
            rows_hash.each do |row_hash|
                write_posts(
                    row_hash, 
                    row_hash['account']['platformId'],
                    'facebook', 
                    row_hash['postUrl'], 
                    row_hash['message'] || row_hash['title'], 
                    row_hash['link'], 
                    row_hash['account']['handle'],
                    row_hash['date'],
                    row_hash['updated'],
                    row_hash['title'] && row_hash['description'] ? (row_hash['title'] + "__" + row_hash['description']) : row_hash['message'],
                    row_hash['score'],
                    'api'
                )
            end
        end
    end

    def self.write_posts(
        row_hash, 
        platform_id, 
        source, 
        url, 
        message, 
        link, 
        user_name, 
        date, 
        updated, 
        link_description,
        score,
        import_type
    )
        node = Node.find_or_create_by(
            url: "https://www.facebook.com/#{platform_id}",
            description: {
                name: platform_id, 
                source: source, 
                user_name: user_name
            }
        )
        post = node.posts.create!(
            archive: row_hash, 
            url: url, 
            title: message, 
            link: link, 
            date: date,
            updated: updated,
            score: score,
            description: {
                import_type: import_type
            }
        )

        if row_hash['expandedLinks']
            row_hash['expandedLinks'].each_with_index do |e,i|
                post.links.create!(
                    url: e['expanded'], 
                    description: {
                        link_description: link_description
                    }
                ) 
            end
        else
            post.links.create!(
                url: link, 
                description: {
                    link_description: link_description
                }
            ) 
        end

    end

end
