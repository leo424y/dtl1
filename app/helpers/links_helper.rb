module LinksHelper
    def url_on_ct(url)
        "https://api.crowdtangle.com/links?token=#{ENV['CT_TOCKEN']}&link=#{url}&sortBy=date".to_s
    end  

    def url_on_informer(url)
        "https://website.informer.com/" + URI.parse(url).host
    end  
end
