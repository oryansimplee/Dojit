class PostPolicy < ApplicationPolicy
	def index?
    	true
  	end

  	def destroy?
    	can_moderate?
  	end

  	def allow_favorite?
  		  user.present?
  	end
end