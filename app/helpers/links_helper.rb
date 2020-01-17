module LinksHelper
    def url_on_ct(url)
        "https://api.crowdtangle.com/links?token=#{ENV['CT_TOCKEN']}&link=#{url}&sortBy=date".to_s
    end  

    def url_on_informer(url)
        host_url = the_host_of(url)
        "https://website.informer.com/#{host_url}"
    end  

    def url_on_publicwww(url)
        host_url = the_host_of(url)
        "https://publicwww.com/websites/%22#{host_url}%22/"
    end  

    def url_on_cofacts(url)
        "https://cofacts.g0v.tw/articles?q=#{url}&filter=all&replyRequestCount=2"
    end  

    private

    def the_host_of(url)
        temp_url = url.start_with?(':') ? url.gsub(':','') : url
        temp_url = temp_url.gsub('https://','').gsub('http://','')
        temp_url = "http://#{temp_url}"
        temp_url.split('/')[2]
    end 
end
