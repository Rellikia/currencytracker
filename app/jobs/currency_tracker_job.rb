class CurrencyTrackerJob < ApplicationJob
  queue_as :default

  before_enqueue do |job|
    Sidekiq::Queue.new(:default).clear

    scheduled_jobs = Sidekiq::ScheduledSet.new
    jobs = scheduled_jobs.select {|retri| retri.queue == :default }
    jobs.each(&:delete)

    retry_jobs = Sidekiq::RetrySet.new
    jobs = retry_jobs.select {|retri| retri.queue == :default }
    jobs.each(&:delete)
  end

  def perform(*args)
    Rails.logger.debug "class=CurrencyTrackerJob method=perform"
    begin
      TrackerService.new.updateCurrencies
      reschedule_job
    rescue Exception => e
      Rails.logger.error "error_key=currency_tracker_job_error message=[#{e.inspect} #{e.message}] location=[#{e.backtrace_locations.try(:first)}] method=perform".freeze
      reschedule_job
    end
  end

  def reschedule_job
    retry_job wait: 30.seconds, queue: :default
  end

end
