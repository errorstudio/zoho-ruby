module Zoho
  module CRM
    class ResponseParserMiddleware < ::Faraday::Response::Middleware

      def on_complete(env)
        json = MultiJson.load(env[:body], :symbolize_keys => true)

        if json[:response][:result].nil?
          env[:body] = {
              data: env[:url].to_s =~ /getRecordById/ ? nil : [],
              errors: json[:response].collect {|k,v| v['message']}
          }
          return
        end
        entity = json[:response][:result].keys.first.to_s.downcase.singularize
        row = Array.wrap(json[:response][:result].values.first[:row])
        records = row.collect do |record|
          fieldlist = record[:FL]
          record_content = fieldlist.inject({}) do |hash, field|

            # Mutate the content to something sensible for nils and dates
            if field[:content] == 'null'
              content = nil
            elsif field[:val] =~ /Time$/i
              content = DateTime.parse(field[:content])
            elsif field[:val] =~ /ID$/i
              content = field[:content].to_i
            else
              content = field[:content]
            end


            field_name = field[:val].to_s.parameterize(separator: "_")

            hash[field_name] = content
            # add an ID field
            hash
          end

        end
        #if this is a singular record request, Her expects an object not an array
        env[:body] = {
          data: env[:url].to_s =~ /getRecordById/ ? records.first : records
        }
      end
    end
  end
end