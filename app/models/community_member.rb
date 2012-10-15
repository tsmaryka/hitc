class CommunityMember < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    street_address   :string, :required
    city             :string, :required
    province         :string, :required
    postal_code      :string, :required
    phone            :string, :required
    primary_language :string, :required
    date_of_birth    :date, :required
    timestamps
  end
  
  belongs_to :user, :class_name => "User", :foreign_key => :user_id
  
  after_create do
   self.user = acting_user
   self.save
  end
  
  def name
  	self.user.name
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.signed_up?
  end

  def update_permitted?
    acting_user.signed_up?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user.signed_up?
  end

end
