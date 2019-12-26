class LinksController < ApplicationController
    def index
        @links = Link.search(params[:url])
        if params[:url].present?
            @link_tops = @links.top_group
            @link_domains = @links.top_domain
        else 
            @link_tops = Link.top_group
            @link_domains = Link.top_domain
        end
        @links = @links.includes(:post).order(created_at: :desc)    

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render xml: @links }
            format.json { render json: @links }
        end
    end
end