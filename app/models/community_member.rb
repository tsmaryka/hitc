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
    true
  end

end
