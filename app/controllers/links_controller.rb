class LinksController < ApplicationController
    def index
        @link_tops = Link.group(:url).count.sort {|a,b| b[1] <=> a[1]}.select { |n| n[1]>2 }
        @link_domains = Link.group(:url).count.sort {|a,b| b[1] <=> a[1]}.select { |n| n[1]>2 }.select { |n| n[0] = n[0].split('/')[2] }.group_by { |a, b| a }.map{ |a, xs|
            [a,
             xs.count]   # true
          }.sort {|a,b| b[1] <=> a[1]}
        @links = Link.search(params[:url]).includes(:post).order(created_at: :desc).limit(100)
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render xml: @links }
            format.json { render json: @links }
        end
    end
end