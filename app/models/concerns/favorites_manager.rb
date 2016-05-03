class FavoritesManager

  attr_reader :user_id

  def initialize(user_id)
    @user_id = user_id
    @client = REDIS
  end

  def favorite_post(post)
    client.multi do
      client.sadd(user_key, post.id)
      client.sadd(self.class.post_key(post), self.user_id)
    end
  end

  def unfavorite_post(post)
    client.multi do
      client.srem(user_key, post.id)
      client.srem(self.class.post_key(post), self.user_id)
    end
  end

  def already_favorited?(post)
    client.sismember(user_key, post.id)
  end

  def my_favorited_post_ids
    client.smembers(user_key)
  end

  def favorited_posts_count
    client.scard(user_key)
  end

  def suggestions
    # i'll leave it up to you guys, keep in mind that "intersections are a powerful tool"
  end

  def FavoritesManager.favorites_for_post(post)
    REDIS.smembers(post_key(post))
  end

  private

  def user_key
    "users:#{self.user_id}:favorited_posts"
  end

  def self.post_key(post)
    "posts:#{post.id}:favorited_by_users"
  end

  def client
    @client
  end
end