class StudyInvitation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    timestamps
  end
  
  belongs_to :community_member
  belongs_to :study

  # --- Permissions --- #

  def create_permitted?
    acting_user.user_type == "manager" || acting_user.user_type == "researcher"
  end

  def update_permitted?
    acting_user.user_type == "manager" || acting_user.user_type == "researcher"
  end

  def destroy_permitted?
    acting_user.user_type == "manager" || acting_user.user_type == "researcher"
  end

  def view_permitted?(field)
    if acting_user.user_type == "manager" || acting_user.user_type == "researcher"
     	return true
    end
    
   	if acting_user.user_type == "community"
   		return self.community_member.user == acting_user
   	end
   		
   	false
  end

end
