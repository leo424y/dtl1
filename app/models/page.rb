# frozen_string_literal: true

class Page < ApplicationRecord
  validates_uniqueness_of :url
  before_save :default_uid
  def default_uid
    self.uid ||= SecureRandom.uuid # note self.status = 'P' if self.status.nil? might be safer (per @frontendbeauty)
  end
end
