# frozen_string_literal: true

class PagesController < ApplicationController
  include Response
  skip_before_action :verify_authenticity_token

  def index
    @page = Page.count_daily_domain 
    domains = []
    @page.each do |p|
      domains << get_host_without_www(p.link)
    end
    grouped_domains = domains.group_by(&:capitalize).map {|k,v| [k, v.length]}.sort_by { |w| w[1] }.reverse

    json_response({result: grouped_domains})
  end


  def create
    @page = Page.new(page_params)
    if @page.save
      json_response(@page, :created)
    else
      json_response(status: 'not saved')
    end
  end
end

private

def page_params
  params.require(:pages).permit(:uname, :pid, :ptitle, :ptype, :pdescription, :ptime, :mtime, :url, :link, :platform, :score)
end

def get_host_without_www(url)
  url = "http://#{url}" if URI.parse(url).scheme.nil?
  host = URI.parse(url).host.downcase
  host.start_with?('www.') ? host[4..-1] : host
end