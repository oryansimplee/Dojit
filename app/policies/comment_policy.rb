class CommentPolicy < ApplicationPolicy
	def index?
    	true
  	end

  	def destroy?
    	can_moderate?
  	end

end