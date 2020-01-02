class LinksController < ApplicationController
    def index
        if params[:url].present?
            @links = Link.search(params[:url])
            @link_tops = @links.top_group
            @link_domains = @links.top_domain
        elsif params[:description].present?
            @links = Link.search_context(params[:description])
            @link_tops = @link_domains = Link.none
        else 
            @links = Link.limit(1000)
            @link_tops = @links.top_group
            @link_domains = @links.top_domain
        end
        @links = @links.includes(:post).order(created_at: :desc)    

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render xml: @links }
            format.json { render json: @links }
        end
    end
end