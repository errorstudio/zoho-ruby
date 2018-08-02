module Zoho
  module CRM
    class Base
      include Her::Model
      include FieldTypeDeclarations
      include FieldCoercions
      use_api -> {Zoho::CRM.configuration.connection}

      def self.inherited(klass)
        klass.send(:collection_path, "#{klass.to_s.demodulize.pluralize}/getRecords")
        klass.send(:primary_key, klass.to_s.demodulize.downcase.singularize + "id")
        klass.send(:resource_path,"#{klass.to_s.demodulize.pluralize}/getRecordById?id=:#{klass.primary_key}")

      end

      def self.first
        all.first
      end

      def self.all(criteria = {})
        results = []
        i = 1
        loop do
          res = super(criteria.merge(fromIndex: i, toIndex: i+199))
          break unless res.any?
          results << res
          i+= 200
        end
        results.flatten
      end

      def self.where(criteria = {})
        results = []
        i = 1
        loop do
          res = super(criteria.merge(fromIndex: i, toIndex: i+199))
          break unless res.any?
          results << res
          i+= 200
        end
        results.flatten
      end

      def self.zoho_entity_name
        self.to_s.demodulize.pluralize
      end



    end
  end
end