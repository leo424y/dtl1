class LinksController < ApplicationController
    def index
        @links = Link.search(params[:url]).order(created_at: :desc).limit(100)
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render xml: @links }
            format.json { render json: @links }
        end
    end
end
