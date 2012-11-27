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

class Study < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title :string
    body :html
    timestamps
  end
 	
 	has_many :study_invitations, :accessible => true, :dependent => :destroy
 	has_many :community_members, :through => :study_invitations
 
 	has_many :study_enrollments, :dependent => :destroy
 	has_many :community_members, :through => :study_enrollments
 	
 	has_many :study_ownerships, :accessible => true, :dependent => :destroy
 	has_many :researchers, :through => :study_ownerships
 	
 	belongs_to :consent_text, :accessible => :true
 	belongs_to :test_module, :accessible => :true
 	
 	lifecycle do
 		state :no_consent, :default => true
 		state :consent_added
 		
 		transition :add_consent, { :no_consent => :consent_added }, :available_to => "User" do
 			
 		end
 	end

	after_create do
		if acting_user.user_type == "researcher"
			ownership = StudyOwnership.new()
			ownership.researcher = Researcher.find(:first, :conditions=> ["user_id = ?", acting_user.id])
			ownership.study = self
			ownership.save
		end
	end
		
  # --- Permissions --- #

  def create_permitted?	
    if acting_user.is_researcher?
    	return true	
    end
  end

  def update_permitted?
    if acting_user.is_manager?
    	return true
    end
    
    if acting_user.is_researcher?
    	if self.id
    		return true
    	end
    	return acting_user.researcher.owns(self)
    end
    
    return false	
  end

  def destroy_permitted?
     return update_permitted?
  end

  def view_permitted?(field)
    if acting_user.is_manager?
    	return true
    end
    
    if acting_user.is_researcher?
    	#TODO determine if this is right
    	if self.id == nil
    		return true
    	end
    	return acting_user.researcher.owns(self)
    end
    
    if acting_user.is_community_member?
    	return acting_user.community_member.is_invited(self)
    end
    
    return false
  end

end
