require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'yaml'
YAML::ENGINE.yamler = 'syck'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module KirjastoData
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib/holdings)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    config.action_view.javascript_expansions[:defaults] = %w()

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.active_record.schema_format = :sql

    config.holdings_implementation = 'AirPacHoldings'
    config.holdings_baseurl = 'http://m.helmet.fi'

    config.lists = {
      "recommendations" =>
      [
       '(FI-HELMET)b1706791',
       '(FI-HELMET)b1706789',
       '(FI-HELMET)b1706788',
       '(FI-HELMET)b1706787',
       '(FI-HELMET)b1706786',
       '(FI-HELMET)b1706785',
       '(FI-HELMET)b1706784',
       '(FI-HELMET)b1706783',
       '(FI-HELMET)b1706782',
       '(FI-HELMET)b1706781',
       '(FI-HELMET)b1706780',
       '(FI-HELMET)b1706779',
       '(FI-HELMET)b1706777'
      ],
      "jazz" =>
      [
       '(FI-HELMET)b1693310',
       '(FI-HELMET)b1693311',
       '(FI-HELMET)b1693313',
       '(FI-HELMET)b1693315',
       '(FI-HELMET)b1693317',
       '(FI-HELMET)b1693318',
      ],
      "finnish_novels" => [
       '(FI-HELMET)b1706803',
       '(FI-HELMET)b1706802',
       '(FI-HELMET)b1706801',
       '(FI-HELMET)b1706800',
       '(FI-HELMET)b1706799'
      ],
      "design_books" => [
       '(FI-HELMET)b1706798',
       '(FI-HELMET)b1706797',
       '(FI-HELMET)b1706796',
       '(FI-HELMET)b1706795',
       '(FI-HELMET)b1706794',
       '(FI-HELMET)b1706793',
       '(FI-HELMET)b1706792'
      ],
    }
  end
end
