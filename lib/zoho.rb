require 'require_all'
require 'her'


module Zoho
  class << self
    attr_accessor :configuration
    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end
  end

  class Configuration
    attr_accessor :user_agent

    def initialize
      @user_agent = "Ruby Zoho client #{Zoho::VERSION} (http://github.com/errorstudio/zoho-ruby)"
    end

  end
  class Error < StandardError

  end
end

require_rel "."
