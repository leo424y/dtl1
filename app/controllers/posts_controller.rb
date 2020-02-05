class PostsController < ApplicationController
    def index
        @posts = (params[:url].present? || params[:description].present? || params[:start_date].present? || params[:end_date].present? ? Post.all : Post.none)
        
        @posts = @posts.search(params[:url]) if params[:url].present? 
        @posts = @posts.search_context(params[:description], 'title') if params[:description].present? 
         
        @posts = @posts.search_date(params, 'date') if (params[:start_date].present? || params[:end_date].present? )

        @post_source= @posts.group(:node).count

        @posts = @posts.order(date: :desc)  

        @type_counts = []
         @post_source.each do |n|
            @type_counts << [n[0]['archive']['source'],n[1]]
         end

         @type_counts = @type_counts.group_by {|i| i[0]}
         @type_counts = @type_counts.map{|i| [i[0],i[1].sum{|x| x[1]}] }

         @first_date = @posts.last.updated
         @last_date = @posts.first.updated

        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render xml: @posts }
          format.json { render json: @posts }
          format.csv { send_data @posts.to_csv("id url link title date updated archive node_id score created_at updated_at"), filename: "posts-#{Date.today}-params-#{params.inspect}.csv" }
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

    def youtube_import
        if params[:file]
            Post.yt_import(params[:file]) 
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
