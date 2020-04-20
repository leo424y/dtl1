# frozen_string_literal: true

class PagesController < ApplicationController
  include Response
  skip_before_action :verify_authenticity_token

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
