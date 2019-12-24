class PostsController < ApplicationController
    def index
        @posts = Post.search(params[:url]).includes(:node).order(date: :desc)
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render xml: @posts }
            format.json { render json: @posts }
        end
    end

    def import
        if params[:file]
            Post.import(params[:file]) 
            redirect_to dashboard_posts_path, notice: 'Post from csv imported'
        else
            redirect_to dashboard_posts_path, notice: 'No CSV'
        end
    end

    def api
        Post.api_import
        
        redirect_to dashboard_posts_path, notice: 'Post from api imported'
    end

    def dashboard
    end
end
