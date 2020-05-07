# frozen_string_literal: true

class BydaysController < ApplicationController
  skip_before_action :verify_authenticity_token

  include Response
  def index
    @byday = (params[:name] || params[:date]) ? Byday.all : Byday.none
    @byday = @byday.where(created_at: params[:date].to_date.beginning_of_day..params[:date].to_date.end_of_day) if params[:date]
    @byday = @byday.where("name LIKE ?", "%#{params[:name]}%") if params[:name]
    json_response(@byday)
  end

  def create
    @byday = Byday.new(name: params[:name], data: params[:data])

    if @byday.save
      json_response(@byday, :created)
    else
      json_response(status: 'not saved')
    end
  end
end
