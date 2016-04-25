require 'rails_helper'

describe "Visiting profiles" do

  include TestFactories

  before do
    @user = authenticated_user
    @post = associated_post(user: @user)
    @comment= comment_without_email(user: @user,post:@post)
    allow(@comment).to receive(:send_favorite_emails)
    @comment.save
  end

  describe "not signed in" do

    it "shows profile" do
      visit user_path(@user)
      expect(current_path).to eq(user_path(@user))
      expect( page ).to have_content(@user.name)
      expect( page ).to have_content(@post.title)
      expect( page ).to have_content(@comment.body)

    end
  end


  describe "a user visits their own profile" do

    it "shows profile" do
      login_as(@user, :scope => :user)
      visit user_path(@user)
      expect(current_path).to eq(user_path(@user))
      expect( page ).to have_content(@user.name)
      expect( page ).to have_content(@post.title)
      expect( page ).to have_content(@comment.body)

    end
  end


end