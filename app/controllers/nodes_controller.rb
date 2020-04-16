# frozen_string_literal: true

class NodesController < ApplicationController
  def index
    if params[:start_date].present? || params[:end_date].present?
      @nodes = Node.search_date(params, 'created_at')
      # @nodes = @nodes.search_context(params[:description], "archive ->> 'user_name'") if params[:description].present?
      @nodes_count = @nodes.count
      @nodes = @nodes.order_by_posts_count
    else
      @nodes = Node.none
      @nodes_count = Node.count
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @nodes }
      format.json { render json: { head: { count: @nodes_count }, body: @nodes } }
      format.csv { send_data @nodes.to_csv('id url archive created_at updated_at domain_id'), filename: "nodes-#{Date.today}-params-#{params.inspect}.csv" }
    end
  end

  def show
    @node = Node.find(params[:id])
  end
end
