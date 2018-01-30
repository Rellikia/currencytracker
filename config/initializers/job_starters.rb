module CurrencyTracker
  class Application < Rails::Application
    config.after_initialize do
      CurrencyTrackerJob.perform_now
    end
  end
end