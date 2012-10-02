class ConsentText < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title :string
    body  :html
    timestamps
  end
  
  has_many :consents
  has_many :users, :through => :consent

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
