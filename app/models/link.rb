class Link < ApplicationRecord
    belongs_to :post

    def self.search(search)
        if search
          where(url: search).order(updated_at: :desc).includes(:post)
        else
          all.order(updated_at: :desc).includes(:post)
        end
    end
end
