require_relative 'type/single'
require_relative 'content/json'
require_relative 'data/redis'

# An Individual Site
class SiteResource < SingleResource
  include JSONSupport
  include RedisSupport

  def resource_exists?
    redis.sismember 'index', id
  end

  def is_conflict?
    redis.exists id
  end

  def delete_resource
    redis.multi do
      redis.del id
      redis.srem 'index', id
    end
    true
  end

  def delete_completed?
    redis.sismember 'index', id == false
  end

  private

  def input
    redis.multi do
      redis.del id
      redis.sadd 'index', id
      payload.each { |key, value| redis.hset id, key, value }
    end
  end

  def output
    redis.hgetall id
  end

  def id
    request.path_info[:id]
  end
end
