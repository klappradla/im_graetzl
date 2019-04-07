PumaWorkerKiller.config do |config|
  # dyno memory quota detection
  case `bash -c 'ulimit -u'`.to_i
  when 256
    # 1X
    config.ram = 512
  when 512
    # 2X
    config.ram = 1024
  when 16_384
    # Performance-M
    config.ram = 2_560
  else
    # Performance-L or unknown
    config.ram = 14_336
  end
  config.frequency = 60 # seconds
  config.percent_usage = (ENV['MAX_MEMORY_USAGE'] || 0.94).to_f
  config.rolling_restart_frequency = false
  Rails.logger.warn "Puma worker killer configured with #{config.ram} MB of RAM (#{config.percent_usage * 100}%)"
end

PumaWorkerKiller.start
