module Zoho
  module CRM
    module Persistence
      extend ActiveSupport::Concern

      class_methods do
        def create(attrs)
          self.new(attrs).save
        end
      end

      # Generate a blob of XML to send to Zoho
      def to_zoho_params
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.send(self.class.zoho_entity_name.to_sym) {
            xml.row(no: "1") {
              # only include changed params
              changes.each do |param,change|
                # if a parameter ends in 'id' or 'ID' we need to make it uppercase - this is how Zoho needs IDs for other associated entities (contacts => accounts for example)
                param_name = param.match(/id$/i) ? param.upcase : param.to_s.humanize.titleize
                xml.send(:FL, {val: param_name}, send(param))
              end
              xml.send(:FL, {val: "Imported Via Api"}, true)
            }
          }
        end
        builder.doc.root.to_xml
      end

      # Save the record. This has to be sent in XML to the correct API path
      def save
        path = persisted? ? update_path : create_path
        self.class.post_raw(path, xmlData: to_zoho_params) do |data, response|
          if response.status == 200
            self.id = Nokogiri::XML.parse(data).css('FL[val=Id]').text
            reload
            clear_changes_information
            self
          end
        end
      end

      def update_path
        "xml/#{self.class.zoho_entity_name}/updateRecords?id=#{self.send(self.class.primary_key)}&wfTrigger=true"
      end

      def create_path
        "xml/#{self.class.zoho_entity_name}/insertRecords?wfTrigger=true"
      end
    end
  end
end