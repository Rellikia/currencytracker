class CurrencyTrackerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    begin
      logger.debug("tracker service")
      TrackerService.new.updateCurrencies

      reschedule_job
    rescue Exception => e
      Rails.logger.error "error_key=currency_tracker_job_error message=[#{e.inspect} #{e.message}] location=[#{e.backtrace_locations.try(:first)}] class=ProductsJob method=perform".freeze
      reschedule_job
    end
  end

  def reschedule_job
    retry_job wait: 30.seconds, queue: :default
  end

end
