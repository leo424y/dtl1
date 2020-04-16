# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :protect

  def protect
    @ips = ENV['IPOK'].split(',')
    render action: 'unauth' unless request.remote_ip.start_with? *@ips
  end

  def unauth
    render 'pages/unauth'
  end
end
