class Crowdtangle < ApplicationRecord
    def self.result (params)
        require 'net/https'
        token = ENV['CT_TOCKEN']
        uri = URI("https://api.crowdtangle.com/posts/search/?token=#{token}&searchTerm=#{URI.escape params[:description]}&startDate=#{params[:start_date]}&endDate=#{(params[:end_date].to_date+1.day).strftime("%Y-%m-%d")}&sortBy=&count=100")
        request = Net::HTTP.get_response(uri)
        rows_hash = JSON.parse(request.body)['message'] || JSON.parse(request.body)['result']['posts']
        api_result 'crowdtangle', params, rows_hash
    end
end