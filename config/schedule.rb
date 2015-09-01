every 1.day do
  runner 'DailyDigestJob.perform_now'
end

every 3.minutes do
  rake 'ts:index'
end


