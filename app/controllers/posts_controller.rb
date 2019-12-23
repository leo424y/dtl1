class PostsController < ApplicationController
    def index
        @posts = Post.none
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render xml: @posts }
            format.json { render json: @posts }
        end
    end

    def import
        Post.import(params[:file])
        redirect_to root_url, notice: 'Post imported'
    end

    def api
        require 'net/https'
        token = ENV['CT_TOCKEN']
        list_id = '1290974'
        uri = URI("https://api.crowdtangle.com/posts?token=#{token}&listIds=#{list_id}")
        request = Net::HTTP.get_response(uri)
        puts request.body if request.is_a?(Net::HTTPSuccess)
        
        redirect_to root_url, notice: 'Post imported'
    end
end
