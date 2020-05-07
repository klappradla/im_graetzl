Rails.application.config.active_job.queue_adapter = :delayed_job
Delayed::Worker.delay_jobs = Rails.env.staging? || Rails.env.production?
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.raise_signal_exceptions = false
