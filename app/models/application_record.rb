class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.api_result platform, params, rows_hash
    {
      source: platform,
      params: params,
      count: rows_hash.is_a?(Array) ? rows_hash.count : rows_hash, 
      # posts: rows_hash,
    }
  end

  def self.to_csv(header)
    attributes = header.split(" ")

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |result|
        csv << attributes.map{ |attr| result.send(attr) }
      end
    end
  end

  def self.search_date(params, date_column)
    if params[:start_date].present? && params[:end_date].present? 
      start_date = params[:start_date].to_date.beginning_of_day
      end_date = params[:end_date].to_date.end_of_day
      where( date_column.to_sym => start_date..end_date+1.day)
    elsif params[:start_date].present?  
      start_date = params[:start_date].to_date.beginning_of_day
      where("#{date_column} >= :start_date", start_date: start_date)
    elsif params[:end_date].present? 
      end_date = params[:end_date].to_date.end_of_day
      where("#{date_column} <= :end_date", end_date: end_date+1.day)
    end
  end  

  def self.search(search)
    if search.present?
      # where(url: search)
      where("url LIKE :url OR url LIKE :urlp OR url LIKE :urls OR url LIKE :str", {:url => "#{search}%", :urlp => "http://#{search}%", :urls => "https://#{search}%", :str => "%#{search}%"})
      # where("url LIKE :url OR url LIKE :urlp OR url LIKE :urls", {:url => "#{search}%", :urlp => "http://#{search}%", :urls => "https://#{search}%"})
    else
      self
    end
  end

  def self.search_context(description, search_column)
    if description.include? '+'
      description = description.split('+')
    else
      description = [description]
    end

    description_orig = description.map{|x| "%#{x}%"}
    
    description_sim = description.map{|x| "%#{Tradsim::to_sim x}%"}
    description_trad = description.map{|x| "%#{Tradsim::to_trad x}%"}

    if description.present?
      where("
        #{search_column} LIKE ALL(ARRAY[:description]) OR 
        #{search_column} LIKE ALL(ARRAY[:s]) OR
        #{search_column} LIKE ALL(ARRAY[:t]) 
        ", description: description_orig, s: description_sim, t: description_trad)
    else
      self
    end
  end   
end
