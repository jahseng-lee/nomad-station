module IssuesHelper
  def helper_issue_entity_link(issue:)
    return "No entity" if issue.entity.nil?

    if issue.entity_type.constantize == Country
      # We don't have a Country page, so link to the Visa page
      # found in additional information Location#name
      location = Location.find_by(
        name: issue.additional_information["location"]
      )

      return link_to(
        location_visa_information_path(
          location_id: location.id
        ),
        target: "_blank"
      ) do
        "<i class='bi bi-box-arrow-up-right'></i>\n" \
          "Reported on visa page for #{location.name_utf8}".html_safe
      end
    end
  end
end
