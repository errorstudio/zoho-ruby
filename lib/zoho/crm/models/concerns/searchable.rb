module Zoho
  module CRM
    module Searchable
      extend ActiveSupport::Concern

      class_methods do
        def find_by_field(field: nil, value: nil)
          raise ArgumentError, "field and query must be provided" unless field.present? && value.present?
          # only the first arg will work
          get(search_path, searchColumn: field, searchValue: value).collect do |result|
            result.id = result.send(primary_key)
            result
          end
        end

        def search_path
          "json/#{zoho_entity_name}/getSearchRecordsByPDC?selectColumns=All"
        end
      end
    end
  end
end