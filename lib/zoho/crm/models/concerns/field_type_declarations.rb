module Zoho
  module CRM
    module FieldTypeDeclarations
      extend ActiveSupport::Concern


      included do

        [
          :picklist,
          :boolean,
          :multi_select,
          :single_line,
          :multi_line,
          :percentage,
          :date,
          :number
        ].each do |type|

          define_singleton_method type do |*fields|
            existing_fields = self.instance_variable_get(:"@#{type}_fields") || self.instance_variable_set(:"@#{type}_fields", [])
            self.instance_variable_set(:"@#{type}_fields", (existing_fields + fields.flatten).uniq)
          end

          define_singleton_method :"#{type}_fields" do
            self.instance_variable_get(:"@#{type}_fields") || []
          end
        end
      end
    end
  end
end