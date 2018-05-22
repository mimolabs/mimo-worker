redis_config = YAML.safe_load(ERB.new(File.read(File.dirname(__FILE__) + '/../redis_server.yml')).result)
REDIS = Redis.new(host: redis_config[Rails.env])
