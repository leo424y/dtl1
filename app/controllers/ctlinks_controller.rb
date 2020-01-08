class CtlinksController < ApplicationController
    def index
        require 'net/https'
        token = ENV['CT_TOCKEN']
        uri = URI("https://api.crowdtangle.com/links?link=#{params[:link]}&token=#{token}&sortBy=total_interactions&count=100")
        request = Net::HTTP.get_response(uri)
        rows_hash = JSON.parse(request.body) if request.is_a?(Net::HTTPSuccess)
        
        respond_to do |format|
            format.json { render json: rows_hash }
        end
    end
end

