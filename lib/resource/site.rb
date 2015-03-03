require_relative 'type/single'
require_relative 'content/json'
require_relative 'data/redis'

# An Individual Site
class SiteResource < SingleResource
  include JSONSupport
  include RedisSupport

  def resource_exists?
    redis.sismember 'sites', id
  end

  def is_conflict?
    redis.exists site_key
  end

  def delete_resource
    redis.multi do
      redis.del site_key
      redis.srem 'sites', id
    end
    true
  end

  def delete_completed?
    redis.sismember 'sites', id == false
  end

  private

  def input
    redis.multi do
      redis.del site_key
      redis.sadd 'sites', id
      payload.each { |key, value| redis.hset site_key, key, value }
    end
  end

  def output
    redis.hgetall site_key
  end

  def site_key
    "site:#{ id }"
  end

  def id
    request.path_info[:id]
  end
end
