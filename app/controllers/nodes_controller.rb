class NodesController < ApplicationController
    def index        
        @nodes = 
        if params[:start_date].present?  || params[:end_date].present? 
          Node.search_date(params)
        else
          Node.all
        end        
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render xml: @nodes }
          format.json { render json: @nodes }
        end
    end
end
