class NodesController < ApplicationController
    def index        
        @nodes = 
        if params[:start_date].present?  || params[:end_date].present? 
          Node.search_date(params, 'created_at').order_by_posts_count
        else
          Node.includes(:posts).order(created_at: :desc).limit(100)
        end
        
        @nodes = @nodes.search_context(params[:description], "archive ->> 'user_name'") if params[:description].present? 

        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render xml: @nodes }
          format.json { render json: @nodes }
          format.csv { send_data @nodes.to_csv("id url archive created_at updated_at domain_id"), filename: "nodes-#{Date.today}-params-#{params.inspect}.csv" }
        end
    end

    def show
      @node = Node.find(params[:id])
    end

end
