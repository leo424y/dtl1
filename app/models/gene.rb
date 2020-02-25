class Gene < ApplicationRecord
    require 'net/https'
    require 'open-uri'


    def self.import(endpoints, params)
        begin
        uri = URI("#{ENV['NEWS_API_ENDPOINT']}/#{endpoints}?date=#{params[:date]}")
        request = Net::HTTP.get_response(uri)
        rows_hash = JSON.parse(request.body)['news_rank'] if request.is_a?(Net::HTTPSuccess)
        rows_hash.merge params
        rescue 
            {}
        end
    end
end