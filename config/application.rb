require_relative "boot"

require "rails/all"
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mondoreg
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.i18n.default_locale = :hu
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    # MyPOS card payment integration:
    config.x.mypos.sid = 351930
    config.x.mypos.wallet_number = 40162416966
    config.x.mypos.key_index = 2
    config.x.mypos.certificate = ENV["MYPOS_CERTIFICATE"]

  end
end
