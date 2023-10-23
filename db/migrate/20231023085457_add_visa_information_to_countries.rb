class AddVisaInformationToCountries < ActiveRecord::Migration[7.0]
  def change
    add_column :countries, :visa_information, :text
  end
end
