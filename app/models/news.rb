class News < ApplicationRecord
    def self.result (params)
        require 'net/https'
        token = ENV['CT_TOCKEN']
        uri = URI("https://#{ENV['ALLOW_DOMAIN']}/posts/news.json?description=#{URI.escape params[:description]}&start_date=#{params[:start_date]}&end_date=#{params[:end_date]}&source=news")
        request = Net::HTTP.get_response(uri)
        rows_hash = JSON.parse(request.body) if request.is_a?(Net::HTTPSuccess)    

        api_result 'news', params, rows_hash
    end
end