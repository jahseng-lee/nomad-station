class Location < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search_by_name,
    against: :name,
    using: {
      tsearch: { prefix: true }
    },
    # TODO this is pretty shit, but can't figure out
    #      how to order better
    order_within_rank: "updated_at DESC"

  belongs_to :country

  has_many :reviews

  has_one :banner_image

  validates :name, :name_utf8, presence: true

  scope :by_region, -> (region_id) {
    joins(:country)
      .where("countries.region_id = ?", region_id)
  }

  scope :by_country, -> (country_id) {
    where(country_id: country_id)
  }

  scope :ordered_for_search_results, -> {
    left_outer_joins(:reviews)
      .group("locations.id")
      .order(
        "avg(reviews.overall) DESC NULLS LAST, count(reviews) DESC NULLS LAST, population desc"
      )
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

  def emergency_numbers
    [
      { name: "ambulance", number: country.ambulance_number },
      { name: "police", number: country.police_number },
      { name: "fire", number: country.fire_number },
    ]
  end

  def has_emergency_numbers?
    emergency_numbers
      .map{ |emergency_number| emergency_number[:number]}
      .any?
  end
end
