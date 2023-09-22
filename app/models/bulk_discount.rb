class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates :discount, numericality: { greater_than: 0, less_than: 1 }
  validates :threshold, numericality: { greater_than: 0, only_integer: true }
  validates_presence_of :name
end