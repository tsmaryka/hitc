class ConsentText < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title :string
    body  :html
    timestamps
  end
  
  has_many :consents
  has_many :users, :through => :consent
  
  belongs_to :study, :class_name => "Study", :foreign_key => :study_id, :accessible => true

  # --- Permissions --- #

  def create_permitted?
    acting_user.is_researcher? || acting_user.is_manager?
  end

  def update_permitted?
		acting_user.signed_up? && acting_user.is_manager?
  end

  def destroy_permitted?
  	if acting_user.signed_up? && acting_user.is_manager?
  		return true
  	end
  	##TODO set up for cascade with study
    return false
  end

  def view_permitted?(field)
  	true
  end

end
