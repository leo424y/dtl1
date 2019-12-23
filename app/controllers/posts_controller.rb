class PostsController < ApplicationController
    def index
        @posts = Post.includes(:node).order(created_at: :desc).limit(100)
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render xml: @posts }
            format.json { render json: @posts }
        end
    end

    def import
        if params[:file]
            Post.import(params[:file]) 
            redirect_to root_url, notice: 'Post imported'
        else
            redirect_to root_url, notice: 'No CSV'
        end
    end

    def api
        Post.api_import
        
        redirect_to root_url, notice: 'Post imported'
    end
end
