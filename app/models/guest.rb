class Guest < Hobo::Model::Guest

  def administrator?
    false
  end
  
  def user_type?
  	"guest"
  end
  
  def is_manager?
  	false
  end
  
  def is_community_member?
  	false
  end	
  
  def is_researcher?
  	false
 	end
  
end
