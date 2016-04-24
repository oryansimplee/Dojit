require 'rails_helper'

describe User do

  include TestFactories

  describe "#favorited(post)" do

  	 before do
      	@post = associated_post
    	@user = authenticated_user
    	@favorite = Favorite.new( post: @post, user: @user)
   	 	
    end

    it "returns `nil` if the user has not favorited the post" do
    	 expect( @user.favorites.find_by_post_id(@post.id) ).to be_nil
    end

    it "returns the appropriate favorite if it exists" do
    		@favorite.save
    	  expect( @user.favorites.find_by_post_id(@post.id).id ).to eq(@post.id)
    end
  end
end