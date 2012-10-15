class Guest < Hobo::Model::Guest

  def administrator?
    false
  end
  
  def user_type?
  	"guest"
  end

end
