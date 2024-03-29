=begin
Copyright 2012 Trevor Maryka

This file is part of Heads in the Cloud.

    Heads in the Cloud is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Heads in the Cloud is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Heads in the Cloud.  If not, see <http://www.gnu.org/licenses/>.
    
=end

class User < ActiveRecord::Base

  hobo_user_model # Don't put anything above this

  fields do
    email_address :email_address, :login => true
    administrator :boolean, :default => false
    timestamps
    user_type enum_string(:community, :researcher, :manager, :referee), :default => :community
    general_consent_accepted :boolean, :required, :default => false
  end
  
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
  
  def name
  	if self.is_community_member?
  		return self.community_member.name
  	end
  	a = self.email_address
  	return a.to_html.sub(' at ', '@').gsub(' dot ', '.')
  end

  # --- Signup lifecycle --- #

  lifecycle do

    state :inactive, :default => true
    state :active

    create :signup, :available_to => "Guest",
      :params => [:email_address, :password, :password_confirmation, :general_consent_accepted],
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
		create :signup_researcher, :available_to => "Guest",
			:params => [:email_address, :password, :password_confirmation, :general_consent_accepted, :user_type],
		 	:become => :inactive, :new_key => true do
		 	if self.user_type == :researcher
		 		UserMailer.activation(self, lifecycle.key).deliver
		 	end
		end

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
  
  def is_manager?
  	self.administrator? || self.user_type == "manager"
  end
  
  def is_community_member?
  	self.user_type == "community" && self.community_details_entered?
  end
  
  def community_member
  	return CommunityMember.find(:first, :conditions=> ["user_id = ?", self])
  end
  
  #a researcher is only a valid researcher if they have entered their details AND been approved by a manager
  def is_researcher?
  	self.user_type == "researcher" && self.researcher_details_entered? && self.researcher.is_approved == true
  end
  
  def researcher
  	return Researcher.find(:first, :conditions=> ["user_id = ?", self])
  end
  
  #check if user has entered a community profile
  def community_details_entered?
  	
  	if self.user_type != "community"
  		return true
  	end
  	if CommunityMember.find(:first, :conditions=> ["user_id = ?", self]) != nil
  		return true
  	end
  	return false
  	
  end
  
  #check if user has entered a researcher profile, and has been approved
  def researcher_details_entered?
  	
  	if self.user_type != "researcher"
  		return true
  	end
  	researcher = Researcher.find(:first, :conditions=> ["user_id = ?", self])
  	if researcher != nil
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
