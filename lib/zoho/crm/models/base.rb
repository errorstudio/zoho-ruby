module Zoho
  module CRM
    class Base
      include Her::Model
      use_api -> {Zoho::CRM.configuration.connection}

      def self.inherited(klass)
        klass.send(:collection_path, "#{klass.to_s.demodulize.pluralize}/getRecords")
        klass.send(:primary_key, klass.to_s.demodulize.downcase.singularize + "id")
        klass.send(:resource_path,"#{klass.to_s.demodulize.pluralize}/getRecordById?id=:#{klass.primary_key}")
        # klass.define_singleton_method :search, ->(criteria) {
        #   raise ArgumentError, "#{klass.to_s}.search takes either a hash or a string" unless (criteria.is_a?(String) || criteria.is_a?(Hash))
        #   if criteria.is_a?(Hash)
        #     criteria_string = criteria.collect {|k,v| "#{k.to_s.titleize}:#{v}"}.join(" AND ")
        #   else
        #     criteria_string = criteria
        #   end
        #   get_collection("#{klass.to_s.demodulize.pluralize}/getRecords?criteria=(#{criteria_string})")
        # }
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



    end
  end
end