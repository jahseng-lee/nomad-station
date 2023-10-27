class Country < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search_by_name,
    against: :name,
    using: {
      tsearch: { prefix: true }
    }

  belongs_to :region, optional: true

  has_many :eligible_countries_for_visas
  has_many :visas
  has_many :locations

  validates :name, presence: true
end
