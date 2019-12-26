class LinksController < ApplicationController
    def index
        @link_tops = Link.top_group
        @link_domains = Link.top_domain
        @links = Link.search(params[:url]).includes(:post).order(created_at: :desc)
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render xml: @links }
            format.json { render json: @links }
        end
    end
end