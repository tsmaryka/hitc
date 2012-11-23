class StudyOwnership < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    timestamps
  end
  
  belongs_to :researcher
  belongs_to :study

  # --- Permissions --- #

  def create_permitted?
   	acting_user.is_manager? || acting_user.is_researcher?
  end

  def update_permitted?
    acting_user.is_manager? || acting_user.is_researcher?
  end

  def destroy_permitted?
    self.view_permitted?(id)
  end

  def view_permitted?(field)
   	if acting_user.signed_up? && acting_user.is_manager?
   		return true
   	end
   	
   	if acting_user.is_researcher?
   		if self.study_id == nil
   			return true
   		end
   		return acting_user.researcher.owns(self.study)
   	end
   	
   	return false
  end

end