class Pablo < ApplicationRecord
    def self.result (params)
        require 'net/http'
        uri = URI.parse("#{ENV['PABLO_API_KEYWORD']}&keyword=#{URI.escape(params[:description])}&position=1&emotion=1&startTime=#{params[:start_date]}&endTime=#{params[:end_date]}&pageIndex=1&pageRows=50")
        response = Net::HTTP.get_response(uri)
        rows_hash = JSON.parse(response.body)['body']
        {pablo: rows_hash}
    end
end