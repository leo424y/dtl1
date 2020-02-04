class DomainsController < ApplicationController
    def index        
        @domains = 
        if params[:start_date].present?  || params[:end_date].present? 
          Domain.search_date(params, 'created_at')
        else
          Domain.includes(:nodes).order(created_at: :desc)
        end        
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render xml: @domains }
          format.json { render json: @domains }
          format.csv { send_data @domains.to_csv("id url archive created_at updated_at"), filename: "domains-#{Date.today}-params-#{params.inspect}.csv" }
        end
    end

    def show
      @domain = Domain.find(params[:id])
    end
end
