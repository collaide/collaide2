# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

#se Rack::CanonicalHost, 'beta.collaide.com' if Rails.env.production?

run Rails.application
