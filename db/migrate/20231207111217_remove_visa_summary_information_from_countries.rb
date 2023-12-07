class RemoveVisaSummaryInformationFromCountries < ActiveRecord::Migration[7.0]
  def change
    remove_column :countries, :visa_summary_information, :text
  end
end
