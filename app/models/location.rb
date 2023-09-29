class Location < ApplicationRecord
  belongs_to :country

  has_many :reviews

  validates :name, :name_utf8, presence: true

  scope :by_region, -> (region_id) {
    joins(:country)
      .where("countries.region_id = ?", region_id)
  }

  scope :by_country, -> (country_id) {
    where(country_id: country_id)
  }

  scope :ordered_for_search_results, -> {
    # TODO change this to be smarter
    order(population: :desc)
  }
end
