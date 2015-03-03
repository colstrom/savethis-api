require 'xxhash'

require_relative 'type/collection'
require_relative 'content/json'
require_relative 'data/redis'

# Collection of Sites
class SitesResource < CollectionResource
  include JSONSupport
  include RedisSupport

  def create_path
    "sites/#{ id }"
  end

  private

  def seed
    @seed ||= redis.get 'seed'
  end

  def id
    @id ||= XXhash.xxh64 payload['url'], seed.to_i
  end

  def input
    redis.multi do
      redis.sadd 'sites', id
      payload.each { |key, value| redis.hset "site:#{ id }", key, value }
    end
  end

  def output
    index = redis.smembers 'sites'
    index.map { |site| redis.hgetall "site:#{ site }" }
  end
end
