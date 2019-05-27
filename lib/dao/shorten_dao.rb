require "redis"

class ShortenDao

  A_WEEK = 60 * 60 * 24 * 7

  def initialize(config)
    @redis = Redis.new(host: config['redis']['host'], port: config['redis']['port'])
  end

  def store_key(key, value)
    @redis.set(key, value, {"ex": A_WEEK, "nx": true})
  end

  def retrieve_key(key)
    @redis.get(key)
  end
end