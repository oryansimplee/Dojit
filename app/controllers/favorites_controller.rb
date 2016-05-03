class FavoritesController < ApplicationController

def create
    post = Post.find(params[:post_id])
    fm= FavoritesManager.new(current_user.id)
    fm.favorite_post(post)
    redirect_to :back
 end

 def destroy
    post = Post.find(params[:post_id])
    fm= FavoritesManager.new(current_user.id)
    fm.unfavorite_post(post)
    redirect_to :back
end

end
