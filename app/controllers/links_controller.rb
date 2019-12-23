class LinksController < ApplicationController
    def index
        @links = Link.search(params[:url])
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render xml: @links }
            format.json { render json: @links }
        end
    end
end
