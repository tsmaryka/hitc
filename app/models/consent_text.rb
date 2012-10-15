class ConsentText < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title :string
    body  :html
    timestamps
  end
  
  has_many :consents
  has_many :users, :through => :consent
  belongs_to :study, :accessible => true

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    true
  end

  def destroy_permitted?
    false
  end

  def view_permitted?(field)
    true
  end

end
