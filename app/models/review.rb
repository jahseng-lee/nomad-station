class Review < ApplicationRecord
  belongs_to :user
  belongs_to :location

  validates :overall,
    :fun,
    :cost,
    :internet,
    :safety,
    presence: true,
    numericality: { in: 1..5 }
end
