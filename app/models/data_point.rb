class DataPoint < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    data :string
    timestamps
  end
  
  belongs_to :study_enrollment

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user.is_researcher? or acting_user.is_manager?
  end

end