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

  def review_summary
    @review_summary ||= {
      overall: reviews.average(:overall).round(1),
      fun: reviews.average(:fun).round(1),
      cost: reviews.average(:cost).round(1),
      internet: reviews.average(:internet).round(1),
      safety: reviews.average(:safety).round(1),
    }
  end
end
