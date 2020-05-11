# frozen_string_literal: true

class Page < ApplicationRecord
  validates_uniqueness_of :url
  before_save :default_uid

  scope :created_between, ->(start_date, end_date) { where('created_at >= ? AND created_at <= ?', start_date, end_date) }

  def default_uid
    self.uid ||= SecureRandom.uuid # note self.status = 'P' if self.status.nil? might be safer (per @frontendbeauty)
  end

  def self.run_api(offset = 0)
    @terms = Gene.import('tag_hot_rank.php', date: Date.today.strftime('%Y-%m-%d')).select.with_index do |x, i|
      x if i > offset * 5 - 1
    end .first(5)
    @terms.each do |t|
      @tag = URI.decode t[1]['tag']

      @ct_data = get_crowdtangle @tag
      @ct_data[:posts].each do |ct|
        @ct_data_page = {
          uname: ct['account']['url'],
          pid: ct['id'],
          ptitle: ct['title'],
          ptype: ct['type'],
          pdescription: ['📝: ', ct['description'], '💬: ', ct['message']].join,
          ptime: ct['date'],
          mtime: ct['updated'],
          url: ct['postUrl'],
          link: ct['expandedLinks'] ? ct['expandedLinks'][0]['expanded'] : ct['link'],
          platform: ct['platform'],
          score: ct['score']
        }
        Page.create(@ct_data_page) if ct['type'] == 'link'
      end
    end
  end

  def self.run_api_serp
    @gene = Gene.import('tag_hot_rank.php', date: Date.today.strftime('%Y-%m-%d'))
    @gene.each_with_index do |g,i|
      if i < 10
        tag = CGI.unescape g[1]['tag']
        api_add = "#{ENV['SERP_API']}?type=add&keyword="
        api_delete = "#{ENV['SERP_API']}?type=delete&keyword="
        delete_tag = '各地分網'
        Net::HTTP.get_response(URI.parse(api_add + CGI.escape(tag)))
        Net::HTTP.get_response(URI.parse(api_delete + CGI.escape(delete_tag)))
        Net::HTTP.get_response(URI.parse(api_add + CGI.escape(Tradsim::to_sim tag)))
        Net::HTTP.get_response(URI.parse(api_delete + CGI.escape(Tradsim::to_sim delete_tag)))
      end
    end
  end

  def self.run_api_pablo
    @gene = Gene.import('tag_hot_rank.php', date: Date.today.strftime('%Y-%m-%d'))
    @gene.each do |g|
      @tag = URI.decode g[1]['tag']
      @pb_data = get_pablo(@tag)
      @pb_data_sim = get_pablo(Tradsim::to_sim @tag)
      Page.write_pablo(@pb_data[:posts]) if @pb_data[:posts]
      Page.write_pablo(@pb_data_sim[:posts]) if @pb_data_sim[:posts]
    end
  end

  def self.write_pablo data
    data.each do |d|
      @pb_data_page = {
        uname: [d['siteName'], d['creator']].join,
        pid: d['articleId'],
        ptitle: d['title'],
        ptype: 'pablo',
        pdescription: [d['area'], ' ', d['content']].join,
        ptime: d['pubTime'],
        mtime: d['cjTime'],
        url: d['url'],
        link: '',
        platform: d['domain'],
        score: d['score']
      }
      Page.create(@pb_data_page)
    end
  end

  def self.get_pablo(term)
    Pablo.result ({
      description: term,
      start_date: Date.today.strftime('%Y-%m-%d'),
      end_date: Date.today.strftime('%Y-%m-%d')
    })
  end

  def self.get_crowdtangle(term)
    Crowdtangle.result(
      description: term,
      start_date: Date.today.strftime('%Y-%m-%d'),
      end_date: Date.today.strftime('%Y-%m-%d')
    )
  end

  def self.count_daily_domain
    where(ptype: 'link').where.not(link: nil).created_between(Time.now - 1.day, Time.now)
  end

  def self.run_daily_domain_summarize
    uri = URI "http://localhost:9999/pages/count_daily_domain"
    request = Net::HTTP.get_response(uri)
    rows_hash = JSON.parse(request.body)['result']
    rows_hash.each do |r|
      if r[1].to_i > 9
        Byday.create(name: r[0], data: r[1]) 
        %x(curl -X POST -H "Content-Type: application/json" -d '{"name": "#{r[0]}","data": "#{r[1]}"}' #{ENV['DTL_API']}/bydays)
      end
    end
  end
end
