class Post < ApplicationRecord
    belongs_to :node
    has_many :links
    paginates_per 50

    def self.yt_import(file)
        require 'csv'
        CSV.foreach(file.path, headers: true) do |row|
            row_hash = row.to_hash
            time = (Time.at row_hash['time'].to_i).strftime("%Y-%m-%d")
            row_hash['time'] = time
            write_posts(
                row_hash, 
                row_hash['id'], 
                'youtube', 
                'https://youtu.be/'+row_hash['id'], 
                row_hash['id'], 
                'https://youtu.be/'+row_hash['id'], 
                'youtube', 
                time,
                time,
                row_hash['view'], 
                row_hash['view'], 
                'csv'
            )
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

    def self.ct_api_import
        ct_api_import_by('posts','date', 100)
        ct_api_import_by('posts','overperforming', 10)
    end

    def self.ct_api_import_by(endpoints, sort_by, count)
        require 'net/https'
        token = ENV['CT_TOCKEN']
        list_ids = ['1290974','1290972']
        list_ids.each do |list_id|
            uri = URI("https://api.crowdtangle.com/#{endpoints}?token=#{token}&listIds=#{list_id}&startDate=#{Date.today.strftime("%Y-%m-%d")}&sortBy=#{sort_by}&count=#{count}")
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
                    sort_by
                )
            end
        end
    end

    def self.news_api_import
        require 'net/http'
        medias = ENV['GENE_NEWS'].split(',')
        medias.each do |media|
            begin
                url = URI("#{ENV['NEWS_API_ENDPOINT']}/news_dump.php?media=#{media}")
                begin
                  uri = URI.parse(url)
                rescue URI::InvalidURIError
                  uri = URI.parse(URI.escape(url))
                end                
            request = Net::HTTP.get_response(uri)
            rows_hash = JSON.parse(request.body)
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
                    'media'
                ) if row_hash['create_time'].to_date == Date.today
            end if rows_hash
            rescue Net::ReadTimeout
             p media+" timeout"
            end
        end
    end

    def self.pablo_api_import
        require 'net/http'
        words = Pablo.pluck(:word)
        words = words + words.map{|w| Tradsim::to_sim w}
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
                    'keywords'
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
        domain_url = URI.parse(url).host
        domain = Domain.find_or_create_by!(
            url: domain_url
        )
        
        node_url = (source == 'facebook') ? "https://www.facebook.com/#{platform_id}" : domain_url
        node = domain.nodes.find_or_create_by!(
            url: node_url,
            archive: {
                source: source, 
                user_name: user_name
            }
        )

        post = node.posts.find_or_create_by(url: url) 
        if post.archive == '{}'
            post.update(
                archive: {data: [row_hash.merge({
                    import_type: import_type
                })]},
                title: message,
                link: link ,
                date: date,
                updated: updated,
                score: score,
                source: source,
            )
            # Create Links
            if row_hash['expandedLinks']
                row_hash['expandedLinks'].each_with_index do |e,i|
                    if e['expanded'] =~ /youtube.com|youtu.be/
                        youtube_meta = JSON.parse(%x(youtube-dl -J "#{link}"))
                        
                        # create the link belongs to facebook post
                        post.links.create!(
                            url: youtube_meta['webpage_url'], 
                            archive: {
                                date: date,
                                link_description: "#{youtube_meta['title']}_#{youtube_meta['description']}"
                            }.merge(youtube_meta)
                        )
        
                        domain_url = 'https://www.youtube.com/'
                        domain = Domain.find_or_create_by!(
                            url: domain_url
                        )
                        
                        node_url = youtube_meta['uploader_url']
                        node = domain.nodes.find_or_create_by!(
                            url: node_url,
                            archive: {
                                source: 'youtube', 
                                user_name: youtube_meta['uploader'],
                                user_id: youtube_meta['uploader_id']
                            }
                        )
                
                        post = node.posts.find_or_create_by(url: link) 
                        post.update(
                            archive: youtube_meta,            
                            title: "#{youtube_meta['title']}_#{youtube_meta['description']}",
                            link: youtube_meta['webpage_url'],
                            date: youtube_meta['upload_date'],
                            updated: updated,
                            score: '',
                            source: 'youtube',
                        )
        
                        # create the link belongs to itself
                        post.links.create!(
                            url: youtube_meta['webpage_url'], 
                            archive: {
                                date: date,
                                link_description: "#{youtube_meta['title']}_#{youtube_meta['description']}"
                            }.merge(youtube_meta)
                        )
                    else
                        post.links.create!(
                            url: e['expanded'], 
                            archive: {
                                link_description: message && link_description ? "#{message}_#{link_description}" : message
                            }
                        ) 
                    end
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
        else
            post.update(
                archive: {data: (post.archive['data'] ? (post.archive['data'] << row_hash) : row_hash)},            
                title: message,
                link: link,
                date: date,
                updated: updated,
                score: score,
                source: source,
            )
        end
        # facebook video download
        %x(curl "http://localhost:3000/?yurl=#{link}") if ( (ENV['FBDL'] == ENV['FBDLS']) && (link =~ /facebook/) && (link =~ /videos/))
        %x(curl "http://localhost:3000/?yurl=#{link}") if ( (ENV['FBDL'] == ENV['FBDLS']) && (link =~ /youtube.com|youtu.be/))
    end
end