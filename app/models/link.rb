class Link < ApplicationRecord
    belongs_to :post

    def self.search(search)
        if search.present?
          # where(url: search)
          where("url LIKE :url OR url LIKE :urlp OR url LIKE :urls OR url LIKE :str", {:url => "#{search}%", :urlp => "http://#{search}%", :urls => "https://#{search}%", :str => "%#{search}%"})
          # where("url LIKE :url OR url LIKE :urlp OR url LIKE :urls", {:url => "#{search}%", :urlp => "http://#{search}%", :urls => "https://#{search}%"})
        else
          self
        end
    end

    def self.search_context(description)
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
          archive ->> 'link_description' LIKE ALL(ARRAY[:description]) OR 
          archive ->> 'link_description' LIKE ALL(ARRAY[:s]) OR
          archive ->> 'link_description' LIKE ALL(ARRAY[:t]) 
          ", description: description_orig, s: description_sim, t: description_trad)
      else
        self
      end
    end

    def self.top_group
      group(:url).count.sort {|a,b| b[1] <=> a[1]}.select { |n| (n[1]> 7)&&(n[0] != nil) } 
    end

    def self.top_domain
      top_group.select { |n| n[0] = n[0] && n[0].split('/')[2] }.group_by { |a, b| a }.map{ |a, xs| ['http://'+a, xs.count]}.sort {|a,b| b[1] <=> a[1]}.select { |n| n[1]> 2 } 
    end
  end
