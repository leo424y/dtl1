module LinksHelper
    def url_on_ct(url)
        "https://api.crowdtangle.com/links?token=#{ENV['CT_TOCKEN']}&link=#{url}&sortBy=date".to_s
    end  

    def url_on_informer(url)
        url = 'http://'+url unless url.start_with?('http')

        "https://website.informer.com/" +  URI.parse(url).host
    end  

    def url_on_publicwww(url)
        url = 'http://'+url unless url.start_with?('http')

        "https://publicwww.com/websites/%22#{URI.parse(url).host}%22/"
    end  

    def url_on_cofacts(url)
        "https://cofacts.g0v.tw/articles?q=#{url}&filter=all&replyRequestCount=2"
    end  
end
