module Zoho
  module CRM
    module FieldCoercions
      extend ActiveSupport::Concern

      included do

        after_find do |record|
          # TODO why is this called twice?
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
            record.class.send(:"#{type}_fields").each do |field|
              if self.class.respond_to?(:"handle_#{type}") && record.respond_to?(field)
                mutated = self.class.send(:"handle_#{type}", record.send(field))
                record.send(:"#{field}=",mutated)
              end
            end
          end
        end
        
        record.created_time = DateTime.parse(record.created_time)
        record.created_at = record.created_time

        record.modified_time = DateTime.parse(record.modified_time)
        record.updated_at = record.modified_time
      end

      # Methods which return the mutated content for each field type
      class_methods do
        def handle_boolean(raw)
          if raw.is_a?(String)
            raw == 'true'
          else
            raw
          end
          
        end

        def handle_picklist(raw)
          if raw.present? && raw.is_a?(String)
            raw.split(";").first #this is for safety really - if it's a picklist, it should only have option option
          else
            raw
          end
        end

        def handle_multi_select(raw)
          if raw.present? && raw.is_a?(String)
            raw.split(";")
          else
            raw
          end
        end

        def handle_single_line(raw)
          raw
        end

        def handle_multi_line(raw)
          raw
        end

        def handle_percentage(raw)
          if raw.present? && raw.is_a?(String)
            raw.to_f
          else
            raw
          end
        end

        def handle_date(raw)
          if raw.present? && raw.is_a?(String)
            Date.parse(raw) rescue raw
          else
            raw
          end
        end

        def handle_number(raw)
          if raw.present? && raw.is_a?(String)
            raw.to_i
          else
            raw
          end
        end
      end



    end
  end
end