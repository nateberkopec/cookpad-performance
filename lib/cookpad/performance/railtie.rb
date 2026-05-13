module Cookpad
  module Performance
    class Railtie < ::Rails::Railtie
      DEFAULTS_IVAR_NAME = "@defaults".freeze
      SHAKAPACKER_PROFILE_CONFIG = "config/shakapacker.profile.yml".freeze

      private_constant :DEFAULTS_IVAR_NAME, :SHAKAPACKER_PROFILE_CONFIG

      config.before_configuration do |app|
        next unless Cookpad::Performance.profile?

        shakapacker_profile_config = app.root.join(SHAKAPACKER_PROFILE_CONFIG)
        ENV["SHAKAPACKER_CONFIG"] ||= SHAKAPACKER_PROFILE_CONFIG if shakapacker_profile_config.exist?
      end

      config.after_initialize do
        next unless Cookpad::Performance.profile?
        next unless defined?(Webpacker)

        default_config = Webpacker.config.instance_variable_get(DEFAULTS_IVAR_NAME)
        default_config["compile"] = false
        Webpacker.config.instance_variable_set(DEFAULTS_IVAR_NAME, default_config)
      end
    end
  end
end
