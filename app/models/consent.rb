class Consent < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    date :date, :required, :default => :now
    timestamps
  end
  
  belongs_to :user
  belongs_to :consent_text

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    false
  end

  def destroy_permitted?
    false
  end

  def view_permitted?(field)
    true
  end

end
