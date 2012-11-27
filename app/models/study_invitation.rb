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

class StudyInvitation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
  	consent_accepted :boolean, :default => false
    timestamps
  end
  
  belongs_to :community_member, :accessible => true
  belongs_to :study, :accessible => true
  
  after_create do
  	print 'mailing invitation'
  	UserMailer.invited(self).deliver
  end
  
  def title
  	study.title
  end
  
  def consent_accepted
  	self.state == :accepted
  end
  
  lifecycle do

    state :invited, :default => true
    state :accepted
    
    transition :accept_invitation, { :invited => :accepted }, :available_to => "User", :params => [ :consent_accepted ] do
    	if :consent_accepted
    	
    		consent = Consent.new()
     		consent.date = DateTime.now
     		consent.user = self.community_member.user
     		consent.consent_text = self.study.consent_text
     		consent.save
     		
     		enroll = StudyEnrollment.new()
     		enroll.study = self.study
     		enroll.community_member = self.community_member
     		enroll.generate_key
     		enroll.save
    		
    	end
    
    end
    
  end

  # --- Permissions --- #

  def create_permitted?
    if acting_user.is_manager?
    	return true
    end
    
    if acting_user.is_researcher?
    	puts self.study.study_ownerships.class
    	if self.study_id == nil || ( self.study.study_ownerships == nil || self.study.study_ownerships.length == 0 )
    		return true
    	end
    	return acting_user.researcher.owns(self.study)
    end
    
    return false
  end

  def update_permitted?
    create_permitted?
  end

  def destroy_permitted?
    create_permitted?
  end

  def view_permitted?(field)
   	if create_permitted?
    	return true
    end
    
    if acting_user.signed_up? && acting_user.is_community_member?
    	return acting_user.community_member == self.community_member
   	end
   	
   	return false
  end

end
