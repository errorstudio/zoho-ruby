module Zoho
  class HeadersMiddleware < Faraday::Middleware
    def call(env)

      env[:request_headers]["User-Agent"] = Zoho.configuration.user_agent
      @app.call(env)
    end
  end
end
