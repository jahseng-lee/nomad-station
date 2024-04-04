class Issue < ApplicationRecord
  belongs_to :reporter,
    foreign_key: :reporter_id,
    optional: true,
    class_name: "User"

  # It may seem like we're replicating string enums here, and it is.
  # But for some reason, string enums aren't playing nice.
  # enum issue_type: { other: "Other" } is actually saving it to the
  # DB as "other", with the capitalised string doing... nothing.
  # This contradicts the docs, so leaving for now...
  MISSING_VISA_INFO = "Missing visa information"
  INCORRECT_VISA_INFO = "Incorrect visa information"
  ERROR_VISA_INFO = "Visa information is not loading/causing error"
  OTHER = "Other"
  ISSUE_TYPES = [
    MISSING_VISA_INFO,
    INCORRECT_VISA_INFO,
    ERROR_VISA_INFO,
    OTHER,
  ]

  validate :issue_type_exists
  validate :issue_type_entity_match
  validate :entity_exists

  scope :unresolved, -> { where(resolved: false) }

  def self.visa_issue_types
    [
      MISSING_VISA_INFO,
      INCORRECT_VISA_INFO,
      ERROR_VISA_INFO,
      OTHER
    ]
  end

  def additional_information
    JSON.parse(self[:additional_information])
  end

  def entity
    return nil if entity_type.nil? || entity_id.nil?

    if entity_type.constantize == Country
      "Country: #{Country.find(entity_id).name}"
    end
  end

  private

  def issue_type_exists
    unless ISSUE_TYPES.include?(issue_type)
      errors.add(
        :issue_type, "must be declared in Issue::ISSUE_TYPES."
      )
    end
  end

  def issue_type_entity_match
    if entity_type == "Country" &&
        !Issue.visa_issue_types.include?(issue_type)
      errors.add(
        :issue_type,
        "must be in Issue.visa_issue_types if the entity_type is" \
          " 'Country'."
      )
    end
  end

  def entity_exists
    return if entity_type.nil?

    if entity_id.nil?
      errors.add(:entity_id, "can't be empty if entity_type is specified")
      return
    end

    if entity_type.constantize.find_by(id: entity_id).nil?
      errors.add(
        :entity_id,
        "can't find entity with entity_type: #{entity_type}," \
          " id: #{entity_id}"
      )
    end
  end
end
