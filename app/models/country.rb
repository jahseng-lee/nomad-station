class Country < ApplicationRecord
  belongs_to :region, optional: true

  has_many :locations

  validates :name, presence: true
end
