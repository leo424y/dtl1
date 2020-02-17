class PostsController < ApplicationController
    def index
        @genes = Gene.import('tag_hot_rank.php', {date: params[:start_date] || Date.today.strftime("%Y-%m-%d")}).to_hash


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

         @first_date = ( @posts.first && (params[:start_date].present? || params[:end_date].present? )) ? @posts.last.updated : nil
         @last_date = (@posts.last && (params[:start_date].present? || params[:end_date].present?)) ? @posts.first.updated : nil

         @posts_date = @posts.pluck(:updated).map{|x| Date.parse(x).strftime("%Y-%m-%d") }.group_by { |month| month }.map{ |month, xs|
            [month,
             xs.count]   # true
          }
          @posts_count= @posts.count

          # cofact
        rumor = "行政院最新公告～元旦放七天嘍！收到這訊息。千萬別點閱，因為有病毒，已有朋友中獎了，請大家告訴大家!如果有收到，元旦放七天，的那個是釣魚網站，別點。"

        @response = (Rumors::Api::Client.search rumor)

        @post_tags= @posts.pluck(:archive).map{|x|x['data'][0]['tags'] if x['data'] && x['data'][0]}.flatten.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }.sort {|a1,a2| a2[1].to_i <=> a1[1].to_i }
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

        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render xml: @post }
          format.json { render json: @post }
        end
    end
end
