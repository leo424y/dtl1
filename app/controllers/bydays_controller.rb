# frozen_string_literal: true

class BydaysController < ApplicationController
  skip_before_action :verify_authenticity_token

  include Response
  def index 
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
