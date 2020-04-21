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
    grouped_domains = domains.group_by(&:capitalize).map {|k,v| [k, v.length]}.sort_by { |w| -w[1] }

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
  url = url[1..-1] if url.start_with? ':'
  url = url.encode(Encoding.find('ASCII'), encoding_options)
  url = "http://#{url}" if URI.parse(url).scheme.nil?
  host = URI.parse(url).host.downcase
  host.start_with?('www.') ? host[4..-1] : host
end

def encoding_options 
  {
    :invalid           => :replace,  # Replace invalid byte sequences
    :undef             => :replace,  # Replace anything not defined in ASCII
    :replace           => '',        # Use a blank for those replacements
    :universal_newline => true       # Always break lines with \n
  }
end