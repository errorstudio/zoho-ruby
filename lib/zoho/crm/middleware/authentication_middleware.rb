module Zoho
  module CRM
    class AuthenticationMiddleware < Faraday::Middleware


      def call(env)
        query = Faraday::Utils.parse_query(env.url.query) || {}
        query['authtoken'] = Zoho::CRM.configuration.auth_token
        query['version'] = Zoho::CRM.configuration.api_version
        query['newFormat'] = Zoho::CRM.configuration.new_format
        env.url.query = Faraday::Utils.build_query(query)
        @app.call env
      end

    end
  end
end