# frozen_string_literal: true

class BydaysController < ApplicationController
  skip_before_action :verify_authenticity_token

  include Response
  def index
    @selected_date = params[:date].to_date
    @name = params[:name]
    @byday = Byday.where(created_at: @selected_date.beginning_of_day..@selected_date.end_of_day)
    @byday = @byday.where("name LIKE ?", "%#{@name}%") if @name
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
