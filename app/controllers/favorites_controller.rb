class FavoritesController < ApplicationController

def favorite
    post = Post.find(params[:post_id])
    $redis.sadd(current_user.id,post.id)
    redirect_to :back
 end

 def unfavorite
    post = Post.find(params[:post_id])
    $redis.srem(current_user.id,post.id)
    redirect_to :back
end

end
