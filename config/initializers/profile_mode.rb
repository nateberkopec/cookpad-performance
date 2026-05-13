if Cookpad::Performance.profile?
  Rails.application.configure do
    config.cache_classes = true
    config.eager_load = true

    config.log_level = ENV.fetch("LOG_LEVEL", "info").to_sym

    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    logger.level     = config.log_level
    config.logger    = ActiveSupport::TaggedLogging.new(logger)

    if config.respond_to?(:active_record)
      config.active_record.verbose_query_logs = false
      config.active_record.migration_error = false
    end

    config.public_file_server.enabled = true
    config.public_file_server.headers = {
      "Cache-Control" => "max-age=315360000, public",
      "Expires" => "Thu, 31 Dec 2037 23:55:55 GMT"
    }

    if config.respond_to?(:assets)
      config.assets.compile = false
      config.assets.digest = true
      config.assets.debug = false
    end

    if config.respond_to?(:action_controller)
      config.action_controller.perform_caching = true
      config.action_controller.enable_fragment_cache_logging = false
    end

    config.action_mailer.perform_caching = false if config.respond_to?(:action_mailer)

    if config.respond_to?(:action_view)
      config.action_view.cache_template_loading = true
      config.action_view.annotate_rendered_view_with_filenames = false
      config.action_view.logger = nil
    end

    config.log_tags = [:request_id]

    config.middleware.delete(Prometheus::Client::Rack::Exporter) if defined?(Prometheus::Client::Rack::Exporter)

    config.after_initialize do
      Rails.logger.level = config.log_level if Rails.logger
      ActiveRecord::Base.logger.level = config.log_level if defined?(ActiveRecord::Base) && ActiveRecord::Base.logger
    end
  end
end
