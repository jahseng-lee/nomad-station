class AddOfficialVisaLinkColumnToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :official_visa_link, :text
  end
end
