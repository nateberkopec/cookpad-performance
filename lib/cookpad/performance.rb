require "logger"
require "rails"
require "cookpad/performance/version"
require "cookpad/performance/engine"
require "cookpad/performance/railtie" if defined?(Rails::Railtie)

module Cookpad
  module Performance
    def self.profile?
      Rails.env.development? && %w(1 true yes).include?(ENV.fetch("PROFILE", "false"))
    end
  end
end
