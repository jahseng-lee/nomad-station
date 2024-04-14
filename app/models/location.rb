class Location < ApplicationRecord
  include PgSearch::Model

  multisearchable(
    against: [:name, :country_name],
    additional_attributes: -> (location) {
      country = Country.find(location.country_id)
      {
        country_name: country.name,
        country_id: country.id,
        region_id: country.region_id,
      }
    }
  )

  belongs_to :country

  has_many :reviews
  has_and_belongs_to_many :tags

  has_one :banner_image

  validates :name, :name_utf8, presence: true

  scope :ordered_for_search_results, -> {
    left_outer_joins(:reviews)
      .group("locations.id")
      .order(
        "avg(reviews.overall) DESC NULLS LAST, count(reviews) DESC NULLS LAST, population desc"
      )
  }

  def country_name
    country.name
  end

  def review_summary
    review_scores = reviews.pluck(
      "avg(overall), "\
      "avg(fun), "\
      "avg(cost), "\
      "avg(internet), "\
      "avg(safety)"
    ).first.map{ |avg| avg.to_f.round(1) }

    @review_summary ||= {
      overall: review_scores[0],
      fun: review_scores[1],
      cost: review_scores[2],
      internet: review_scores[3],
      safety: review_scores[4],
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
