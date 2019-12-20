class PostsController < ApplicationController
    def index
        @posts = Post.all
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render xml: @posts }
            format.json { render json: @posts }
        end
    end

    def import
        Post.import(params[:file])
        redirect_to root_url, notice: 'Post imported'
    end
end
