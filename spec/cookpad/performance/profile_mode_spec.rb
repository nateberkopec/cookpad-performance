require "spec_helper"
require "active_support/railtie"
require "active_record/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

RSpec.describe "Profile mode" do
  context "when ENV variable PROFILE is 'true'" do
    before do
      set_environment_variable("RAILS_ENV", "development")
      set_environment_variable("PROFILE", "true")
    end

    it "sets cache_classes to true" do
      set_test_app_configuration(:cache_classes, false)

      expect { load_initializer! }.to change {
        test_app.config.cache_classes
      }.from(false).to(true)
    end

    it "sets eager_load to true" do
      set_test_app_configuration(:eager_load, false)

      expect { load_initializer! }.to change {
        test_app.config.eager_load
      }.from(false).to(true)
    end

    it "sets log_level to :info" do
      set_test_app_configuration(:log_level, :debug)

      expect { load_initializer! }.to change {
        test_app.config.log_level
      }.from(:debug).to(:info)
    end

    it "allows LOG_LEVEL to override the profile default" do
      set_environment_variable("LOG_LEVEL", "warn")
      set_test_app_configuration(:log_level, :debug)

      expect { load_initializer! }.to change {
        test_app.config.log_level
      }.from(:debug).to(:warn)
    ensure
      set_environment_variable("LOG_LEVEL", nil)
    end

    it "sets active_record.verbose_query_logs to false" do
      set_test_app_configuration(:active_record, :verbose_query_logs, true)

      expect { load_initializer! }.to change {
        test_app.config.active_record.verbose_query_logs
      }.from(true).to(false)
    end

    it "sets active_record.migration_error to false" do
      set_test_app_configuration(:active_record, :migration_error, true)

      expect { load_initializer! }.to change {
        test_app.config.active_record.migration_error
      }.from(true).to(false)
    end

    it "sets public_file_server.enabled to true" do
      set_test_app_configuration(:public_file_server, :enabled, false)

      expect { load_initializer! }.to change {
        test_app.config.public_file_server.enabled
      }.from(false).to(true)
    end

    it "sets public_file_server.headers to far-future cache headers" do
      set_test_app_configuration(:public_file_server, :headers, {})

      expect { load_initializer! }.to change {
        test_app.config.public_file_server.headers
      }.from({}).to({
        "Cache-Control" => "max-age=315360000, public",
        "Expires" => "Thu, 31 Dec 2037 23:55:55 GMT"
      })
    end

    it "sets assets.compile to false" do
      set_test_app_configuration(:assets, :compile, true)

      expect { load_initializer! }.to change {
        test_app.config.assets.compile
      }.from(true).to(false)
    end

    it "sets assets.debug to false" do
      set_test_app_configuration(:assets, :debug, true)

      expect { load_initializer! }.to change {
        test_app.config.assets.debug
      }.from(true).to(false)
    end

    it "sets assets.digest to true" do
      set_test_app_configuration(:assets, :digest, false)

      expect { load_initializer! }.to change {
        test_app.config.assets.digest
      }.from(false).to(true)
    end

    it "sets action_controller.perform_caching to true" do
      set_test_app_configuration(:action_controller, :perform_caching, false)

      expect { load_initializer! }.to change {
        test_app.config.action_controller.perform_caching
      }.from(false).to(true)
    end

    it "sets action_controller.enable_fragment_cache_logging to false" do
      set_test_app_configuration(:action_controller, :enable_fragment_cache_logging, true)

      expect { load_initializer! }.to change {
        test_app.config.action_controller.enable_fragment_cache_logging
      }.from(true).to(false)
    end

    it "sets action_mailer.perform_caching to false" do
      set_test_app_configuration(:action_mailer, :perform_caching, true)

      expect { load_initializer! }.to change {
        test_app.config.action_mailer.perform_caching
      }.from(true).to(false)
    end

    it "sets action_view.cache_template_loading to true" do
      set_test_app_configuration(:action_view, :cache_template_loading, false)

      expect { load_initializer! }.to change {
        test_app.config.action_view.cache_template_loading
      }.from(false).to(true)
    end

    it "sets action_view.annotate_rendered_view_with_filenames to false" do
      set_test_app_configuration(:action_view, :annotate_rendered_view_with_filenames, true)

      expect { load_initializer! }.to change {
        test_app.config.action_view.annotate_rendered_view_with_filenames
      }.from(true).to(false)
    end

    it "sets action_view.logger to nil" do
      set_test_app_configuration(:action_view, :logger, Logger.new($stdout))

      expect { load_initializer! }.to change {
        test_app.config.action_view.logger
      }.to(nil)
    end

    it "sets log_tags to [:request_id]" do
      set_test_app_configuration(:log_tags, [])

      expect { load_initializer! }.to change {
        test_app.config.log_tags
      }.from([]).to([:request_id])
    end
  end

  private

    def load_initializer!
      load("config/initializers/profile_mode.rb")
    end
end
