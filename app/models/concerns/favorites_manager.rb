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

  def suggestions(my_posts)
    # i'll leave it up to you guys, keep in mind that "intersections are a powerful tool"

    #Get all the posts that our user has favourited.
    favorite_posts = my_favorited_post_ids
    similar_users=  [].to_set
    result = []
    posts = {} #hash: key- post_id, val - counter

  #From each of this posts get all the users that like those posts . 
    favorite_posts.each do |p|
        users = client.smembers( self.class.post_id_key(p))
        similar_users.merge(users)
    end

  #From all of those users get all of their favourite posts and rank them by popolarity
    similar_users.each do |u|
        u_posts = client.smembers( self.class.user_id_key(u))
        u_posts.each do |up|
        	if  my_posts.map{|x| x[:id]}.include?(up) || favorite_posts.include?(up) 
        	else
        		if posts.has_key?(up)
        			old_val= posts[up]
        			posts[up]=old_val +1
        		else
        			posts[up]=1
        		end
        	end
  	
        end
    end
    #Get the most popular posts from the previous step, that are not already our user's favourite posts
    list= Hash[posts.sort_by{|k, v| v}.reverse]

    list.each do |l|
    	result.push(l[0])
    end
    #Post.where(post_id: favorite_posts)
    result



  end

  def FavoritesManager.favorites_for_post(post)
    REDIS.smembers(post_key(post))
  end

  private

  def user_key
    "users:#{self.user_id}:favorited_posts"
  end

  def self.post_key(post)
    self.post_id_key(post.id)
  end

  def self.post_id_key(post_id)
    "posts:#{post_id}:favorited_by_users"
  end

  def self.user_id_key(user_id)
    "users:#{user_id}:favorited_posts"
  end


  def client
    @client
  end
end