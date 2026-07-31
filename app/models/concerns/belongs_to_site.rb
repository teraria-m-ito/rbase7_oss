# coding: utf-8
module BelongsToSite
  extend ActiveSupport::Concern

  included do
    belongs_to :site, optional: true
  end
end
