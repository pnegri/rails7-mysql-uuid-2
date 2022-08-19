Rails.application.config.generators do |g|
  g.orm :active_record, primary_key_type: 'binary, limit: 16'
end
