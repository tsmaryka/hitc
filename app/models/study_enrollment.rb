class StudyEnrollment < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    timestamps
  end
  
  belongs_to :community_member
  belongs_to :study
  
  # --- Permissions --- #

  def create_permitted?
    acting_user.user_type == "community" && acting_user.community_details_entered?
  end

  def update_permitted?
    self.community_member.user = acting_user
  end

  def destroy_permitted?
    self.community_member.user = acting_user
  end

  def view_permitted?(field)
    self.community_member.user = acting_user || acting_user.user_type == "manager"
  end

end
