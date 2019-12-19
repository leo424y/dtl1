class NodesController < ApplicationController
    def index
        @nodes = Node.all
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render xml: @nodes }
          format.json { render json: @nodes }
        end
    end
end
