module Zoho
  module CRM
    module FieldTypes
      extend ActiveSupport::Concern

      included do
        FIELD_TYPES = [
          :picklist,
          :boolean,
          :multi_select,
          :single_line,
          :multi_line,
          :percent
        ]

        class << self
          attr_reader *(FIELD_TYPES.collect {|t| :"#{t}_fields"})
        end
        FIELD_TYPES.each do |type|

          define_singleton_method type do |*fields|
            existing_fields = self.instance_variable_get(:"@#{type}_fields") || self.instance_variable_set(:"@#{type}_fields", [])
            self.instance_variable_set(:"@#{type}_fields", (existing_fields + fields.flatten).uniq!)
          end
        end
      end


    end
  end
end