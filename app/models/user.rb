class User < ActiveRecord::Base

  hobo_user_model # Don't put anything above this

  fields do
    name          :string, :required, :unique
    email_address :email_address, :login => true
    administrator :boolean, :default => false
    timestamps
    user_type enum_string(:community, :researcher, :manager, :referee), :default => :community
    general_consent_accepted :boolean, :required, :default => false
  end
  
  has_many :study_invitations, :dependent => :destroy
  has_many :studies, :through => :study_invitations
  
  has_many :consents, :dependent => :destroy
  has_many :consent_texts, :through => :consents

  # This gives admin rights and an :active state to the first sign-up.
  # Just remove it if you don't want that
  before_create do |user|
    if !Rails.env.test? && user.class.count == 0
      user.administrator = true
      user.state = "active"
    end
  end


  # --- Signup lifecycle --- #

  lifecycle do

    state :inactive, :default => true
    state :active

    create :signup, :available_to => "Guest",
      :params => [:name, :email_address, :password, :password_confirmation, :general_consent_accepted],
      :become => :inactive, :new_key => true  do
      UserMailer.activation(self, lifecycle.key).deliver
      #add the consent acceptance
     	consent = Consent.new()
     	consent.date = DateTime.now
     	consent.user = self
     	consent.consent_text = ConsentText.find(:first, :conditions=> ["title = ?","General Consent"])
     	consent.save
    end
  
  #TODO create lifecycles for adding researchers, referees and managers
  #  create :add_researcher, :available_to => "User",
   # 	:params => [:name, :email_address, :password, :password_confirmation]
  #  	:become => :inactive, :new_key => true do
    	

    transition :activate, { :inactive => :active }, :available_to => :key_holder do
    	acting_user = self
    end

    transition :request_password_reset, { :inactive => :inactive }, :new_key => true do
      UserMailer.activation(self, lifecycle.key).deliver
    end

    transition :request_password_reset, { :active => :active }, :new_key => true do
      UserMailer.forgot_password(self, lifecycle.key).deliver
    end

    transition :reset_password, { :active => :active }, :available_to => :key_holder,
               :params => [ :password, :password_confirmation ]

  end

  def signed_up?
    state=="active"
  end
  
  #check if user has entered a community profile
  def community_details_entered?
  	
  	if self.user_type != "community"
  		puts "not community"
  		return true
  	end
  	if CommunityMember.find(:first, :conditions=> ["user_id = ?", self]) != nil
  		return true
  	end
  	return false
  	
  end

  # --- Permissions --- #

  def create_permitted?
    # Only the initial admin user can be created
    self.class.count == 0
  end

  def update_permitted?
    acting_user.administrator? ||
      (acting_user == self && only_changed?(:email_address, :crypted_password,
                                            :current_password, :password, :password_confirmation))
    # Note: crypted_password has attr_protected so although it is permitted to change, it cannot be changed
    # directly from a form submission.
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end
end
