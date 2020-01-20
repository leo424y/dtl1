class PostsController < ApplicationController
    def index
        @posts = (params[:url].present? || params[:title].present? ? Post.all : Post.none)
        
        @posts = @posts.search(params[:url]) if params[:url].present? 
        @posts = @posts.search_context(params[:title], 'title') if params[:title].present? 
         
        @posts = @posts.search_date(params) if (params[:start_date].present? || params[:end_date].present? )

          
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
        Post.ct_api_import
        
        redirect_to dashboard_posts_path, notice: 'Post from api imported'
    end

    def dashboard
    end

    def show
        @post=Post.find(params[:id])
    end
end
