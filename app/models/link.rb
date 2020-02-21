class Link < ApplicationRecord
    belongs_to :post
    paginates_per 50


    def self.top_group
      group(:url).count.sort {|a,b| b[1] <=> a[1]}.select { |n| (n[1]> 7)&&(n[0] != nil) } 
    end

    def self.top_domain
      top_group.select { |n| n[0] = n[0] && n[0].split('/')[2] }.group_by { |a, b| a }.map{ |a, xs| ['http://'+a, xs.count]}.sort {|a,b| b[1] <=> a[1]}.select { |n| n[1]> 2 } 
    end
  end
