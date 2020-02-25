class LinksController < ApplicationController
    def index
      @genes = Gene.import('tag_hot_rank.php', {date: params[:start_date] || Date.today.strftime("%Y-%m-%d")}).to_hash

      # Get Links
      @links = (params[:url].present? || params[:description].present? || params[:start_date].present? || params[:end_date].present? ? Link.all : Link.none)

      @links = @links.search(params[:url]) if params[:url].present? 
      @links = @links.search_context(params[:description], "archive ->> 'link_description'") if params[:description].present? 
      @links = @links.search_date(params, 'created_at') if (params[:start_date].present? || params[:end_date].present? )


      # Get Link statics
      @link_by_counts = @links.top_group
      @link_by_domains = @links.top_domain
      
      
      @links = @links.includes(:post).order(created_at: :desc)

      @links_by_page = @links.page params[:page]

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @links }
        format.csv { send_data @links.to_csv("id url archive created_at updated_at post_id"), filename: "links-#{Date.today}-params-#{params.inspect}.csv" }
      end
    end
end



# TODO
# # Node statics
# @nodes = Node.pluck(:archive)
      
# @old_nodes = []
# @new_nodes = []

# @nodes.each do |n|
#     @old_nodes << n['name']
#     @old_nodes << n['user_name']
# end
# @link_tops_nodes = @link_tops.map{|a| a[0].include?('facebook') ? a[0] : nil }.compact.map{|x| x.split('/')[3]}.map{|x| (x.length < 40) ? x : nil}.uniq
# @new_nodes = @link_tops_nodes - @old_nodes - ['groups','act', 'notes', 'hashtag']
