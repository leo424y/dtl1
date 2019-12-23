class Link < ApplicationRecord
    belongs_to :post

    def self.search(search)
        if search
          where(url: search)
        else
          all
        end
    end
end
