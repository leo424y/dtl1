class Pablo < ApplicationRecord
    def self.result (params)
        require 'net/http'
        uri = URI.parse("#{ENV['PABLO_API_KEYWORD']}&keyword=#{URI.escape(params[:description])}&position=1&emotion=1&startTime=#{params[:start_date]}&endTime=#{params[:end_date]}&pageIndex=1&pageRows=99999")
        begin
            response = Timeout::timeout(28) { Net::HTTP.get_response(uri)}
            rows_hash = JSON.parse(response.body)['body']['list'].select{|k| k['pubTime'].split(' ')[0].to_date.between?(params[:start_date].to_date, params[:end_date].to_date)}
            {result: {source: 'pablo', count: rows_hash.count, posts: rows_hash}}
        rescue
            {result: 'timeout'}
        end
    end
end