class Link < ApplicationRecord
    belongs_to :post

    def self.search(search)
        if search
          where(url: search)
        else
          limit(50)
        end
    end

    def self.top_group
      group(:url).count.sort {|a,b| b[1] <=> a[1]}.select { |n| n[1]> 5 } 
    end

    def self.top_domain
      top_group.select { |n| n[0] = n[0] && n[0].split('/')[2] }.group_by { |a, b| a }.map{ |a, xs| [a, xs.count]}.sort {|a,b| b[1] <=> a[1]}.select { |n| n[1]> 2 } 
    end
  end
