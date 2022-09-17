class ApplicationJob < ActiveJob::Base
  include ConnectAndValidate, GetStaticFeatures, GetDynamicFeatures, GetRelationalFeatures, SetFeatures, UpdateFeatures
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
end
