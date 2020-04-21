# frozen_string_literal: true

class Page < ApplicationRecord
  validates_uniqueness_of :url
  before_save :default_uid

  scope :created_between, lambda {|start_date, end_date| where("created_at >= ? AND created_at <= ?", start_date, end_date )}

  def default_uid
    self.uid ||= SecureRandom.uuid # note self.status = 'P' if self.status.nil? might be safer (per @frontendbeauty)
  end

  def self.run_api offset = 0
    @terms = Gene.import('tag_hot_rank.php', date: Date.today.strftime('%Y-%m-%d')).select.with_index{|x,i| x if i>offset*5-1}.first(5)
    @terms.each do |t|
      @tag =  URI.decode t[1]['tag']

      @ct_data = get_crowdtangle @tag
      @ct_data[:posts].each do |ct|
        @ct_data_page = {
          uname: ct['account']['url'],
          pid: ct['id'],
          ptitle: ct['title'],
          ptype: ct['type'],
          pdescription: ['📝: ',ct['description'],'💬: ',ct['message']].join,
          ptime: ct['date'],
          mtime: ct['updated'],
          url: ct['postUrl'],
          link: ct['expandedLinks'] ? ct['expandedLinks'][0]['expanded'] : ct['link'],
          platform: ct['platform'],
          score: ct['score'],
        }
        Page.create(@ct_data_page) if (ct['type'] == 'link')
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

  def self.count_daily_domain
    where(ptype: 'link').where.not(link: nil).created_between(Time.now-1.day, Time.now)
  end
end
