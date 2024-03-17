class AddCountryAndRegionToSearchDocuments < ActiveRecord::Migration[7.0]
  def change
    add_reference :pg_search_documents, :region, index: true
    add_reference :pg_search_documents, :country, index: true
  end
end
