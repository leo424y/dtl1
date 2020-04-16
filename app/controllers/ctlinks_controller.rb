# frozen_string_literal: true

class CtlinksController < ApplicationController
  def index
    if params[:link].present?
      require 'net/https'
      token = ENV['CT_TOCKEN']
      uri = URI("https://api.crowdtangle.com/links?link=#{params[:link]}&token=#{token}&sortBy=total_interactions&count=100&startDate=#{params[:start_date]}&endDate=#{params[:end_date]}")
      request = Net::HTTP.get_response(uri)
      rows_hash = JSON.parse(request.body) if request.is_a?(Net::HTTPSuccess)
    else
      rows_hash = { result: "param 'link' is required" }
    end

    respond_to do |format|
      format.json { render json: rows_hash }
    end
  end
end
