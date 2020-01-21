class NodesController < ApplicationController
    def index        
        @nodes = 
        if params[:start_date].present?  || params[:end_date].present? 
          Node.search_date(params, 'created_at')
        else
          Node.includes(:posts).order(created_at: :desc).limit(100)
        end        
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render xml: @nodes }
          format.json { render json: @nodes }
        end
    end

    def show
      @node = Node.find(params[:id])
    end

end
