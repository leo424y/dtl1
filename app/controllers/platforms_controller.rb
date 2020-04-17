# frozen_string_literal: true

class PlatformsController < ApplicationController
  include Response

  def index

    @terms = Gene.import('tag_hot_rank.php', date: Date.today.strftime('%Y-%m-%d')).to_hash.first(6)
    @terms.each do |t|
      p t[1]['tag']
      # @ct_data = get_crowdtangle t[1]['tag']
      @ct_data[:posts].each do |ct|
        @ct_data_page = {
          uname: ct['account']['url'],
          pid: ct['platformId'],
          ptitle: ct['title'],
          ptype: ct['type'],
          pdescription: ['description: ',ct['description'],'message: ',ct['message']].join,
          ptime: ct['date'],
          mtime: ct['updated'],
          url: ct['postUrl'],
          platform: ct['platform'],
          score: ct['score'],
        }
        Page.create @ct_data_page
      end
    end
  end

  private
  def get_crowdtangle term
    Crowdtangle.result({
      description: term, 
      start_date: Date.today.strftime('%Y-%m-%d'), 
      end_date: Date.today.strftime('%Y-%m-%d')
      })
  end
end
