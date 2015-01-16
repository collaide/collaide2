require File.expand_path('../boot', __FILE__)

require 'rails/all'
Bundler.require(*Rails.groups)

module Collaide2
  class Application < Rails::Application

    #I18n Settings
    config.time_zone = 'Paris'
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :fr
    config.i18n.available_locales = [:fr]

    config.active_record.raise_in_transactional_callbacks = true

    # Social keys for networks authentication
    social_keys = File.join(Rails.root, 'config', 'social_keys.yml')
    CONFIG = HashWithIndifferentAccess.new(YAML::load(IO.read(social_keys)))[Rails.env]
    CONFIG.each do |k,v|
      ENV[k.upcase] ||= v
    end
  end
end
