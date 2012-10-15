class StudyOwnership < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    timestamps
  end
  
  belongs_to :researcher
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
    acting_user.user_type == "manager" || acting_user.user_type == "researcher"
  end

end
