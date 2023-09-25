class Country < ApplicationRecord
  belongs_to :region, optional: true

  has_many :countries

  validates :name, presence: true
end
