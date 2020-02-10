class DomainsController < ApplicationController
    def index        
        if params[:start_date].present? || params[:end_date].present? 
          @domains = Domain.search_date(params, 'created_at').order_by_nodes_count
        else
          @domains = Domain.order_by_nodes_count
        end

        @domains_count = Domain.count

        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render xml: @domains }
          format.json { render json: {head: {count: @domains_count}, body: @domains } }
          format.csv { send_data @domains.to_csv("id url archive created_at updated_at"), filename: "domains-#{Date.today}-params-#{params.inspect}.csv" }
        end
    end

    def show
      @domain = Domain.find(params[:id])
    end
end
