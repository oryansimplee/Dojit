class PostPolicy < ApplicationPolicy
	def index?
    	true
  	end

  	def destroy?
    	can_moderate?
  	end

  	def allowFavorite?
  		  user.present?
  	end
end