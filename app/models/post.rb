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

    def self.ct_api_import
        require 'net/https'
        token = ENV['CT_TOCKEN']
        list_ids = ['1290974','1290972']
        list_ids.each do |list_id|
            uri = URI("https://api.crowdtangle.com/posts?token=#{token}&listIds=#{list_id}&startDate=#{Date.today.strftime("%Y-%m-%d")}&sortBy=date&count=100")
            request = Net::HTTP.get_response(uri)
            rows_hash = JSON.parse(request.body)['result']['posts'] if request.is_a?(Net::HTTPSuccess)
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

    def self.news_api_import
        require 'net/http'
        medias = ENV['GENE_NEWS'].split(',')
        medias.each do |media|
            begin
            uri = ("#{ENV['NEWS_API_ENDPOINT']}/news_dump.php?media=#{media}")
            request =  HTTParty.get(uri, timeout: 120)
            rows_hash = JSON.parse(request)
            rows_hash.each do |row_hash|
                write_posts(
                    row_hash, 
                    media,
                    'news', 
                    row_hash['url'], 
                    [media, row_hash['title'], row_hash['tags'].join(' '), row_hash['creator'], row_hash['description']].join(' '),
                    row_hash['url'], 
                    row_hash['creator'],
                    row_hash['create_time'],
                    row_hash['create_time'],
                    row_hash['description'],
                    '',
                    'api'
                )
            end
            rescue Net::ReadTimeout
            #   p media+" timeout"
            end
        end
    end

    def self.pablo_api_import
        require 'net/http'
        words = ENV['PABLO_KEYWORDS'].split(',')
        words.each do |word|
            uri = URI.parse("#{ENV['PABLO_API_KEYWORD']}&keyword=#{URI.escape(word)}&position=1&emotion=1&startTime=#{Date.today.strftime("%Y-%m-%d")}&endTime=#{Date.today.strftime("%Y-%m-%d")}&pageIndex=1&pageRows=50")
            response = Net::HTTP.get_response(uri)
            rows_hash = JSON.parse(response.body)['body']['list']
            rows_hash.each do |row_hash|
                write_posts(
                    row_hash, 
                    row_hash['siteName'],
                    'pablo', 
                    row_hash['url'], 
                    [row_hash['siteName'], row_hash['title'], row_hash['creator'], row_hash['content']].join(' '),
                    row_hash['url'], 
                    [row_hash['siteName'],row_hash['creator']].join(' '),
                    row_hash['pubTime'],
                    row_hash['pubTime'],
                    row_hash['content'],
                    '',
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
            url: (source == 'facebook') ? "https://www.facebook.com/#{platform_id}" : platform_id,
            archive: {
                name: platform_id, 
                source: source, 
                user_name: user_name
            }
        )
        post = node.posts.find_or_create_by!(
            archive: row_hash.merge({
                import_type: import_type
            }), 
            url: url, 
            title: message, 
            link: link, 
            date: date,
            updated: updated,
            score: score
        )

        if row_hash['expandedLinks']
            row_hash['expandedLinks'].each_with_index do |e,i|
                post.links.create!(
                    url: e['expanded'], 
                    archive: {
                        link_description: message && link_description ? "#{message}_#{link_description}" : message
                    }
                ) 
            end
        else
            post.links.create!(
                url: link, 
                archive: {
                    date: date,
                    link_description: message && link_description ? "#{message}_#{link_description}" : message
                }
            ) 
        end

        # facebook video download
        %x(curl "http://localhost:3000/?yurl=#{link}") if ( (ENV['FBDL'] == ENV['FBDLS']) && (link =~ /facebook/) && (link =~ /videos/))
    end
end