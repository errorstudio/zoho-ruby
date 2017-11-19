module Zoho
  module CRM
    class << self
      attr_accessor :configuration
      def configure
        Zoho.configure {} if Zoho.configuration.nil?
        self.configuration ||= Configuration.new
        yield(configuration)
        self.configuration.configure_connection
      end
    end

    class Configuration
      attr_accessor :auth_token, :proxy, :ssl_options, :send_only_modified_attributes, :base_url, :api_version, :user_agent, :new_format
      attr_reader :connection

      def initialize
        @send_only_modified_attributes ||= nil
        @ssl_options = {}
        @proxy = nil
        @connection ||= Her::API.new
        @base_url ||= 'https://crm.zoho.eu/crm/private/json'
        @api_version ||= 2
        @user_agent ||= "Ruby Zoho client #{Zoho::VERSION} (http://github.com/errorstudio/zoho-ruby)"
        @new_format ||= 2
      end

      def configure_connection

        @connection.setup url: @base_url, ssl: @ssl_options, proxy: @proxy, send_only_modified_attributes: @send_only_modified_attributes do |c|

          # Auth
          c.use Zoho::CRM::AuthenticationMiddleware

          # Other headers
          c.use Zoho::HeadersMiddleware

          # Request
          c.use Faraday::Request::UrlEncoded


          # Response
          # c.use Her::Middleware::DefaultParseJSON
          c.use Zoho::CRM::ResponseParserMiddleware
          # Adapter
          c.use Faraday::Adapter::NetHttp
        end

      end
    end
  end
end