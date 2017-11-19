module Zoho
  module CRM
    class Base
      include Her::Model
      use_api -> {Zoho::CRM.configuration.connection}

      def self.inherited(klass)
        klass.send(:collection_path, "#{klass.to_s.demodulize.pluralize}/getRecords")
        klass.send(:primary_key, klass.to_s.demodulize.downcase.singularize + "id")
        klass.send(:resource_path,"#{klass.to_s.demodulize.pluralize}/getRecordById?id=:#{klass.primary_key}")
      end

      def self.first
        all.first
      end

    end
  end
end