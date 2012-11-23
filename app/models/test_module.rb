class TestModule < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    module_identifier   :integer, :required => true
    name 						:string, 	:required => true
    timestamps
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.is_manager?
  end

  def update_permitted?
    acting_user.is_manager?
  end

  def destroy_permitted?
    acting_user.is_manager?
  end

  def view_permitted?(field)
    true
  end

end
