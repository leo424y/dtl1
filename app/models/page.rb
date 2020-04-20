# frozen_string_literal: true

class Page < ApplicationRecord
  validates_uniqueness_of :url
  before_save :default_uid
  def default_uid
    self.uid ||= SecureRandom.uuid # note self.status = 'P' if self.status.nil? might be safer (per @frontendbeauty)
  end

  def self.run_api
    @terms = Gene.import('tag_hot_rank.php', date: Date.today.strftime('%Y-%m-%d')).to_hash.first(6)
    @terms.each do |t|
      @tag =  URI.decode t[1]['tag']

      @ct_data = get_crowdtangle @tag
      @ct_data[:posts].each do |ct|
        @ct_data_page = {
          uname: ct['account']['url'],
          pid: ct['platformId'],
          ptitle: ct['title'],
          ptype: ct['type'],
          pdescription: ['📝: ',ct['description'],'💬: ',ct['message']].join,
          ptime: ct['date'],
          mtime: ct['updated'],
          url: ct['postUrl'],
          link: ct['link'],
          platform: ct['platform'],
          score: ct['score'],
        }
        Page.create @ct_data_page
      end
    end
  end

  def self.get_crowdtangle term
    Crowdtangle.result({
      description: term, 
      start_date: Date.today.strftime('%Y-%m-%d'), 
      end_date: Date.today.strftime('%Y-%m-%d')
      })
  end
end
