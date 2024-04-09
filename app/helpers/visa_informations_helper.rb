module VisaInformationsHelper
  def helper_edit_visa_info_heading(location:, visa_information:)
    heading = "Editing visa information for #{location.country.name}"
    if visa_information.citizenship.present?
      heading << " for citizens of #{visa_information.citizenship.name}"
    end

    heading
  end
end
