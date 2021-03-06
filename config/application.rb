require File.expand_path('../boot', __FILE__)

require 'rails/all'
Bundler.require(*Rails.groups)

module Speculator
  class Application < Rails::Application
    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*',
          :headers => :any,
          :expose  => ['X-Page', 'X-PageTotal'],
          :methods => [:get, :post, :delete, :put, :options]
      end
    end
    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')
    config.i18n.default_locale = :en
    config.active_record.raise_in_transactional_callbacks = true

    config.active_job.queue_adapter = :delayed_job
  end
end
