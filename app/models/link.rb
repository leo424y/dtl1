class Link < ApplicationRecord
    belongs_to :post

    def self.search(search)
        if search
          where(url: search).order(updated_at: :desc).includes(:post)
        else
          order(updated_at: :desc).includes(:post).limit(1000)
        end
    end
end
