require 'hiredis'
require 'redis'

# Mixin to expose Redis to resources
module RedisSupport
  def redis
    @redis ||= Redis.new
  end
end
